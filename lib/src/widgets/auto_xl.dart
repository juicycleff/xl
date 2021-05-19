/// ##  `AutoXL`
/// Provide `layers`, receive `XL`; simple as that.
library xl;

import 'package:flutter/widgets.dart';

import '../models/dragging.dart';
import '../models/layer.dart';
import 'xl.dart';

/// {@macro auto_xl}
///
/// Provide `layers`, receive `XL`; simple as that.
class AutoXL extends StatelessWidget {
  /// `AutoXL.pane` is intended to be mostly stationary but
  /// rotate in its place to represent pointer hovers or accelerometer data.
  ///
  /// Great for a surface intended as a inter/reactive pane.
  ///
  /// This `AutoXL` defaults depth to `2`, meaning any more than two layers
  /// and the remainder will have equivalent parallax factors to the second.
  ///
  /// An `AutoXL.pane` also defaults [supportsSensors] to `false`,
  /// [drag] to `40ms`, and [duration] to `100ms`.
  const AutoXL.pane({
    Key? key,
    required this.layers,
    this.supportsPointer = true,
    this.supportsSensors = false,
    this.depth = 2,
    this.duration = const Duration(milliseconds: 100),
    this.curve = Curves.ease,
    this.drag = const Duration(milliseconds: 40),
  })  : _threeD = (!supportsPointer && !supportsSensors) ? 0 : 0.003,
        _baseOffset = 0.0,
        _layerOffset = (!supportsPointer && !supportsSensors) ? 0 : 10.0,
        _baseRotation = (!supportsPointer && !supportsSensors) ? 0 : 1.0,
        _layerRotation = (!supportsPointer && !supportsSensors) ? 0 : 0.25,
        _baseZ = 0.0,
        _layerZ = 0.0,
        super(key: key);

  /// `AutoXL.wiggler` is intended to wiggle and rotate a little bit
  /// in its place to represent pointer hovers or accelerometer data.
  ///
  /// This `AutoXL` defaults depth to `-1`, meaning each progressive layer
  /// will have a greater parallax factor than the previous.
  const AutoXL.wiggler({
    Key? key,
    required this.layers,
    this.supportsPointer = true,
    this.supportsSensors = true,
    this.depth = -1,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.ease,
    this.drag = const Duration(milliseconds: 100),
  })  : _threeD = (!supportsPointer && !supportsSensors) ? 0 : 0.0015,
        _baseOffset = (!supportsPointer && !supportsSensors) ? 0 : 15.0,
        _layerOffset = (!supportsPointer && !supportsSensors) ? 0 : 25.0,
        _baseRotation = (!supportsPointer && !supportsSensors) ? 0 : 0.25,
        _layerRotation = (!supportsPointer && !supportsSensors) ? 0 : 0.1,
        _baseZ = (!supportsPointer && !supportsSensors) ? 0 : 0.1,
        _layerZ = (!supportsPointer && !supportsSensors) ? 0 : 0.1,
        super(key: key);

  /// `AutoXL.deep` is intended to translate and rotate greatly
  /// in its place to represent pointer hovers or accelerometer data.
  ///
  /// This `AutoXL` defaults depth to `-1`, meaning each progressive layer
  /// will have a greater parallax factor than the previous.
  const AutoXL.deep({
    Key? key,
    required this.layers,
    this.supportsPointer = true,
    this.supportsSensors = true,
    this.depth = -1,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.ease,
    this.drag = const Duration(milliseconds: 100),
  })  : _threeD = (!supportsPointer && !supportsSensors) ? 0 : 0.0015,
        _baseOffset = (!supportsPointer && !supportsSensors) ? 0 : 40.0,
        _layerOffset = (!supportsPointer && !supportsSensors) ? 0 : 30.0,
        _baseRotation = (!supportsPointer && !supportsSensors) ? 0 : 0.3,
        _layerRotation = (!supportsPointer && !supportsSensors) ? 0 : 0.2,
        _baseZ = (!supportsPointer && !supportsSensors) ? 0 : 0.15,
        _layerZ = (!supportsPointer && !supportsSensors) ? 0 : 0.025,
        super(key: key);

  /// {@template auto_xl}
  /// Deploy an `AutoXL` to simplify the setup of an [XL] stack.
  /// {@endtemplate}
  ///
  /// Provide `List<Widget>` [layers] and `double` [depthFactor]
  /// (and optionally a max [depth] for parallax effects) to create
  /// an `XL` with progressively more parallax-reactive layers.
  ///
  /// Override `duration` and `curve` to control parallax animation.
  ///
  /// Default `depth == -1` which means *no* max layer depth
  /// for parallax effects.
  ///
  /// Default `depthFactor == 20.0` which is between
  /// [AutoXL.wiggler] and [AutoXL.deep].
  const AutoXL({
    Key? key,
    double depthFactor = 20.0,
    required this.layers,
    this.supportsPointer = true,
    this.supportsSensors = true,
    this.depth = -1,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.ease,
    this.drag = const Duration(milliseconds: 100),
  })  : _threeD = (!supportsPointer && !supportsSensors) ? 0 : 0.0015,
        _baseOffset =
            (!supportsPointer && !supportsSensors) ? 0 : depthFactor - 10,
        _layerOffset = (!supportsPointer && !supportsSensors) ? 0 : depthFactor,
        _baseRotation =
            (!supportsPointer && !supportsSensors) ? 0 : depthFactor * 0.0025,
        _layerRotation =
            (!supportsPointer && !supportsSensors) ? 0 : depthFactor * 0.001,
        _baseZ =
            (!supportsPointer && !supportsSensors) ? 0 : depthFactor * 0.0015,
        _layerZ =
            (!supportsPointer && !supportsSensors) ? 0 : depthFactor * 0.0015,
        super(key: key);

  /// A `List<Widget>` that will be used to generate progressively
  /// more reactive [XLayer]s for this widget's [XL].
  ///
  /// Constructor choice (or `depthFactor` parameter in [AutoXL]) determines
  /// how much the parallax factor progresses with each `layer`.
  ///
  /// Any `layer` that comes after the [depth]-equivalent `layer` will
  /// have the same parallax animation factor values as the previous.
  final List<Widget> layers;

  /// Initialize `false` to disable this `AutoXL` from reacting to pointer data.
  ///
  /// Default is `true`.
  final bool supportsPointer;

  /// Initialize `false` to disable this `AutoXL` from reacting to sensors data.
  ///
  /// Default is `true`, except for [AutoXL.pane]
  /// which is pointer-focused stack.
  final bool supportsSensors;

  /// Any layers past this number will have the same parallax effect factors
  /// (offsets, rotations).
  ///
  /// Default is `-1` and triggers *every* layer to have progressively
  /// greater parallax factor values than the previous layer,
  /// except for [AutoXL.pane] which defaults to `2`.
  ///
  /// ___
  /// Example: `depth == -1` (default) with [layers] `length == 4`,
  /// the second, third, fourth layer will all have greater
  /// parallax factors than the last.
  ///
  /// ___
  /// Example: `depth == 2` with [layers] `length == 4`,
  /// the second, third and fourth layers will all have
  /// the same parallax factors.
  final int depth;

  /// `Duration` for parallax animations for this `AutoXL`'s [XL] widget. \
  /// Default is `200ms`, except for [AutoXL.pane] which defaults `100ms`.
  final Duration duration;

  /// `Curve` for parallax animations for this `AutoXL`'s [XL] widget. \
  /// Default is [Curves.ease].
  final Curve curve;

  /// `Duration` for parallax animations for this `AutoXL`'s [XL] widget
  /// *during* a pointer hover/drag. \
  /// Default is `100ms`, except for [AutoXL.pane] which defaults `40ms`.
  final Duration drag;

  final double _threeD;
  final double _baseOffset;
  final double _layerOffset;
  final double _baseRotation;
  final double _layerRotation;
  final double _baseZ;
  final double _layerZ;

  @override
  Widget build(BuildContext context) {
    final generatedLayers = <Widget>[];
    final type = (supportsSensors && supportsPointer) ||
            (supportsSensors && !supportsPointer)
        ? XLayer
        : PLayer;

    var currentDepth = 0.0;
    for (final layer in layers) {
      final offset = _baseOffset + _layerOffset * currentDepth;
      final rotation = _baseRotation + _layerRotation * currentDepth;
      generatedLayers.add(
        (type == XLayer)
            ? XLayer(
                dimensionalOffset: _threeD + 0.001 * currentDepth,
                xOffset: offset,
                yOffset: offset,
                xRotation: rotation,
                yRotation: rotation,
                zRotationByX: _baseZ + _layerZ * currentDepth,
                child: layer,
              )
            : PLayer(
                dimensionalOffset: _threeD + 0.001 * currentDepth,
                xOffset: offset,
                yOffset: offset,
                xRotation: rotation,
                yRotation: rotation,
                zRotation: _baseZ + _layerZ * currentDepth,
                child: layer,
              ),
      );
      // -1 is special & default case for "no max depth"
      if (depth == -1 || currentDepth < depth - 1) currentDepth++;
    }

    return XL(
      layers: generatedLayers,
      sharesPointer: supportsPointer,
      sharesSensors: supportsSensors,
      dragging: Dragging(duration: drag),
      duration: duration,
      curve: curve,
    );
  }
}
