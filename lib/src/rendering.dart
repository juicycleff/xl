/// Defines [XLParentData], [StaticXL], and [RenderXL]
library xl;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// `ParentData` for use with [StaticXL].
class XLParentData extends ContainerBoxParentData<RenderBox> {
  /// The horizontal offset of the child's transformation
  double? xOffset;

  /// The vertical offset of the child's transformation
  double? yOffset;

  /// The x rotation of the child's transform.
  double? xRotation;

  /// The y rotation of the child's transform.
  double? yRotation;

  /// The z rotation of the child's transform according to xFactor.
  double? zRotationByX;

  /// The z rotation of the child's transform
  /// according to gyro Z rotation.
  double? zRotationByZ;

  /// Whether the child's transform should have a "3D entrypoint".
  bool? enable3d;

  /// The "v" of setEntry in the child's transformation.
  /// Represents 3D intensity.
  double? dimensionalOffset;

  /// Whether this layer should respond to sensors data or pointers.
  ///
  /// This is applied by `PLayer`s as `false`,
  /// while `XLayer`s have this flagged `true`.
  bool? useSensors;
}

/// {@template static_xl}
/// A `StaticXL` which does not animate its children.
///
/// It is to be controlled by an implicitly animated `AnimatedXL`.
/// {@endtemplate}
class StaticXL extends MultiChildRenderObjectWidget {
  /// {@macro static_xl}
  StaticXL({
    Key? key,
    required List<Widget> children,
    required this.xFactor,
    required this.yFactor,
    required this.sensorFactorX,
    required this.sensorFactorY,
    required this.sensorFactorZ,
  }) : super(key: key, children: children);

  /// {@macro pointer_factor}
  final double xFactor;

  /// {@macro pointer_factor}
  final double yFactor;

  /// {@macro sensor_factor}
  final double sensorFactorX;

  /// {@macro sensor_factor}
  final double sensorFactorY;

  /// {@macro sensor_factor}
  final double sensorFactorZ;

  @override
  RenderXL createRenderObject(BuildContext context) {
    return RenderXL(
      xFactor,
      yFactor,
      sensorFactorX,
      sensorFactorY,
      sensorFactorZ,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderXL renderObject) {
    renderObject
      ..xFactor = xFactor
      ..yFactor = yFactor
      ..sensorFactorX = sensorFactorX
      ..sensorFactorY = sensorFactorY
      ..sensorFactorZ = sensorFactorZ;
  }
}

/// {@template render_xl}
/// Implements the `XL` layout and paint.
/// The [RenderXL] lays out its children based on their
/// respective offsets. By default, the [StaticXL]'s size will
/// match it's largest child's size.
///
/// It also takes in several axes `factor`s.
/// It uses these to transform the child.
/// {@endtemplate}
class RenderXL extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, XLParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, XLParentData> {
  /// {@macro render_xl}
  RenderXL(
    double xFactor,
    double yFactor,
    double sensorFactorX,
    double sensorFactorY,
    double sensorFactorZ,
  )   : _xFactor = xFactor,
        _yFactor = yFactor,
        _sensorFactorX = sensorFactorX,
        _sensorFactorY = sensorFactorY,
        _sensorFactorZ = sensorFactorZ;

  double _xFactor, _yFactor, _sensorFactorX, _sensorFactorY, _sensorFactorZ;

  /// Set the `xFactor` of the `XL`
  set xFactor(double xFactor) {
    _xFactor = xFactor;
    markNeedsPaint();
  }

  /// Set the `yFactor` of the `XL`
  set yFactor(double yFactor) {
    _yFactor = yFactor;
    markNeedsPaint();
  }

  /// Set the `sensorFactorX` of the `XL`
  set sensorFactorX(double sensorFactorX) {
    _sensorFactorX = sensorFactorX;
    markNeedsPaint();
  }

  /// Set the `sensorFactorY` of the `XL`
  set sensorFactorY(double sensorFactorY) {
    _sensorFactorY = sensorFactorY;
    markNeedsPaint();
  }

  /// Set the `sensorFactorZ` of the `XL`
  set sensorFactorZ(double sensorFactorZ) {
    _sensorFactorZ = sensorFactorZ;
    markNeedsPaint();
  }

  @override
  bool get sizedByParent => true;

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! XLParentData) child.parentData = XLParentData();
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      Size(constraints.maxWidth, constraints.maxHeight);

  @override
  void performLayout() {
    var currentChild = firstChild;
    for (var i = 0; i < childCount; i++) {
      currentChild?.layout(
        BoxConstraints(
          maxWidth: constraints.maxWidth,
          maxHeight: constraints.maxHeight,
        ),
      );
      currentChild = (currentChild?.parentData as XLParentData).nextSibling;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    var currentChild = firstChild;

    for (var i = 0; i < childCount; i++) {
      final childParentData = currentChild?.parentData as XLParentData;

      final transform = Matrix4.translationValues(
        -(childParentData.xOffset ?? 0) *
            (childParentData.useSensors ?? false ? _sensorFactorX : _xFactor),
        -(childParentData.yOffset ?? 0) *
            (childParentData.useSensors ?? false ? _sensorFactorY : _yFactor),
        0.0,
      );
      if (childParentData.enable3d ?? false) {
        transform.setEntry(3, 2, childParentData.dimensionalOffset ?? 0.001);
      }
      final xRotation = childParentData.xRotation ?? 0.0;
      final yRotation = childParentData.yRotation ?? 0.0;
      final zRotationX = childParentData.zRotationByX ?? 0.0;
      final zRotationZ = childParentData.zRotationByZ ?? 0.0;
      transform
        ..rotateX(xRotation *
            -(childParentData.useSensors ?? false ? _sensorFactorY : _yFactor))
        ..rotateY(yRotation *
            (childParentData.useSensors ?? false ? _sensorFactorX : _xFactor))
        ..rotateZ(zRotationX *
            (childParentData.useSensors ?? false ? _sensorFactorX : _xFactor))
        ..rotateZ(zRotationZ * _sensorFactorZ);
      final effectiveTransform = _effectiveTransform(transform);

      context.pushTransform(
        needsCompositing,
        offset,
        effectiveTransform,
        (context, offset) =>
            context.paintChild(currentChild!, childParentData.offset + offset),
      );
      currentChild = childParentData.nextSibling;
    }
  }

  Matrix4 _effectiveTransform(Matrix4 transform) {
    final result = Matrix4.identity();
    final translation = Alignment.center.alongSize(size);
    result
      ..translate(translation.dx, translation.dy)
      ..multiply(transform)
      ..translate(-translation.dx, -translation.dy);
    return result;
  }
}
