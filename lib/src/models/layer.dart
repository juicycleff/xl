/// Defines [PLayer]
/// - An extended `ParentDataWidget<XLParentData>`
///
/// Defines [XLayer]
/// - An extended `PLayer`
library xl;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../rendering.dart';

/// {@macro player}
class PLayer extends ParentDataWidget<XLParentData> {
  /// {@template player}
  /// A `Layer` in an `XL`. These by themselves are not `Widget`s.
  ///
  /// Each `Layer` serves as a blueprint for transformations to its [child]
  /// within a parent `XL`, containing all the animatable properties.
  ///
  /// These `Players`s react primarily to pointer data;
  /// that is, either mouse hovers or touch inputs.
  /// {@endtemplate}
  const PLayer({
    Key? key,
    this.xOffset = 0,
    this.yOffset = 0,
    this.xRotation = 0.0,
    this.yRotation = 0.0,
    this.zRotation = 0.0,
    this.enable3d = true,
    this.dimensionalOffset = 0.001,
    this.offset = const Offset(0, 0),
    required Widget child,
  }) : super(key: key, child: child);

  /// How much the [child] should translate on the horizontal
  /// axis when a pointer event occurs.
  final double xOffset;

  /// How much the [child] should translate on the vertical
  /// axis when a pointer event occurs.
  final double yOffset;

  /// How much the [child] should rotate on the X-axis when
  /// a pointer event occurs. The nature of the rotation is up-down.
  final double xRotation;

  /// How much the [child] should rotate on the Y-axis when
  /// a pointer event occurs. The nature of the rotation is left-right.
  final double yRotation;

  /// How much the [child] should rotate on the Z-axis when
  /// a horizontal pointer event occurs.
  ///
  /// If the goal is actually to "spin" the widget as the pointer
  /// moves laterally across the screen, ensure this value is non-zero.
  final double zRotation;

  /// Whether the [child] should be transformed with a 3D perspective effect.
  ///
  /// This alters the transformation matrix value `(3,2)`
  /// with [dimensionalOffset], intensifying or weakening the
  /// perspective change.
  final bool enable3d;

  /// The intensity of the 3D change in perspective activated by [enable3d].
  /// Defaults to `0.001`.
  final double dimensionalOffset;

  /// The offset at which to paint the child in the parent's coordinate system.
  final Offset offset;

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is XLParentData);
    final parentData = renderObject.parentData as XLParentData
      ..useSensors = false; // XLayers flag this true

    var needsLayout = false;
    var needsPaint = false;

    if (parentData.xOffset != xOffset) {
      parentData.xOffset = xOffset;
      needsPaint = true;
      needsLayout = true;
    }
    if (parentData.yOffset != yOffset) {
      parentData.yOffset = yOffset;
      needsPaint = true;
      needsLayout = true;
    }
    if (parentData.xRotation != xRotation) {
      parentData.xRotation = xRotation;
      needsPaint = true;
      needsLayout = true;
    }
    if (parentData.yRotation != yRotation) {
      parentData.yRotation = yRotation;
      needsPaint = true;
      needsLayout = true;
    }
    if (parentData.zRotationByX != zRotation) {
      parentData.zRotationByX = zRotation;
      needsPaint = true;
      needsLayout = true;
    }
    if (parentData.enable3d != enable3d) {
      parentData.enable3d = enable3d;
      needsPaint = true;
      needsLayout = true;
    }
    if (parentData.dimensionalOffset != dimensionalOffset) {
      parentData.dimensionalOffset = dimensionalOffset;
      needsPaint = true;
      needsLayout = true;
    }
    if (parentData.offset != offset) {
      parentData.offset = offset;
      needsPaint = true;
      needsLayout = true;
    }

    final targetParent = renderObject.parent;
    if (targetParent is RenderObject) {
      if (needsLayout) targetParent.markNeedsLayout();
      if (needsPaint) targetParent.markNeedsPaint();
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => StaticXL;
}

/// {@macro xlayer}
class XLayer extends PLayer {
  /// {@template xlayer}
  /// A `Layer` in an `XL`. These by themselves are not `Widget`s.
  ///
  /// Each `Layer` serves as a blueprint for transformations to its [child]
  /// within its parent and contains all the animatable properties.
  /// Keep in mind that axes will depend on device orientation.
  ///
  /// The [xOffset], [yOffset], [xRotation], [yRotation], and `zRotationByX`
  /// are reactionary to their respective axes when it comes to
  /// `AccelerometerEvent`s.
  ///
  /// The [zRotationByGyro], however, is a secondary Z-axis
  /// "spin" factor whose core value is derived from `GyroscopeEvent`s.
  /// - This means that samples from the gyroscope for Z-axis "spins"
  /// with this property, according to `Normalization.samplingRate`, will spike
  /// but return to `0` immediately once the device has finished "spinning".
  /// {@endtemplate}
  const XLayer({
    Key? key,
    double xOffset = 0.0,
    double yOffset = 0.0,
    double xRotation = 0.0,
    double yRotation = 0.0,
    double zRotationByX = 0.0,
    this.zRotationByGyro = 0.0,
    bool enable3d = true,
    double dimensionalOffset = 0.001,
    Offset offset = const Offset(0, 0),
    required Widget child,
  }) : super(
          key: key,
          xOffset: xOffset,
          yOffset: yOffset,
          xRotation: xRotation,
          yRotation: yRotation,
          zRotation: zRotationByX,
          enable3d: enable3d,
          dimensionalOffset: dimensionalOffset,
          offset: offset,
          child: child,
        );

  /// How much the [child] should spin on the z axis when
  /// a z-axis gyroscope movement is sampled.
  ///
  /// If the goal is actually to "spin" the widget as the *device* spins,
  /// this value should be non-zero.
  ///
  /// As gyroscope events are read non-zero only as an axis movement
  /// *is occuring*, this `XLayer` can read rapidly different values
  /// depending on sampling rate and when the rotation was in motion.
  ///
  /// Furthermore this value will normalize itself down to near 0,
  /// or whatever the "stationary" z-axis value is for the gyroscope,
  /// beginning immediately after any jump in value is sampled.
  ///
  /// ### Example Usage Scenario
  /// Use a large `zRotationByGyro` to spin the line-wound reel of
  /// a fishing pole as a mobile phone is "flicked" to simulate casting a line.
  final double zRotationByGyro;

  @override
  Type get debugTypicalAncestorWidgetClass => StaticXL;

  @override
  void applyParentData(RenderObject renderObject) {
    super.applyParentData(renderObject);
    assert(renderObject.parentData is XLParentData);
    final parentData = (renderObject.parentData as XLParentData)
      ..useSensors = true; // PLayers flag this false

    if (parentData.zRotationByZ != zRotationByGyro) {
      parentData.zRotationByZ = zRotationByGyro;
      final targetParent = renderObject.parent;
      if (targetParent is RenderObject) {
        targetParent
          ..markNeedsPaint()
          ..markNeedsLayout();
      }
    }
  }
}
