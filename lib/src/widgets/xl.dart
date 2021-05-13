/// Incorporates the [XL] widget into the `XL` stack.
/// - Combines this package's sensor and pointer listeners
/// with an implicitly animated [AnimatedXL].
library xl;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../animation.dart';
import '../calculation.dart';
import '../gestures.dart';
import '../models/dragging.dart';
import '../models/layer.dart';
import '../models/normalization.dart';
import '../models/reference_position.dart';
import '../sensors.dart';

/// {@macro xl}
class XL extends StatefulWidget {
  /// {@template xl}
  /// A `Widget` that allows the definition of a stack of `XLayer`s
  /// and/or `PLayer`s and that will intrinsically animate them
  /// with a parallax effect based on sensor events (`X`)
  /// or pointer data (`P`).
  ///
  /// ### Layers
  /// A list of [XLayer]s and/or [PLayer]s, each with their own
  /// animatable properties.
  ///
  /// ### Sharing Input
  /// If this `XL` has both `XLayer`s *and* `PLayer`s, control the sharing of
  /// sensors or pointer data with the opposing `Layer` variety
  /// with the respective flags:
  /// - `sharesPointer`
  /// - `sharesSensors`
  ///
  /// ### Dragging
  /// A parameter class that pertains to `PLayer`s and their parallax animation
  /// during an active drag or pointer hover event.
  ///
  /// ### Normalization
  /// A parameter class that pertains to `XLayer`s
  /// for customizing the intake of `SensorEvent` data.
  /// - [Normalization.autocompensates], a flag for toggling autocompensation
  /// after steady sensor samples for some time
  /// - [Normalization.delay], how long to wait before kicking in
  /// autocompensation, considering `sensitivity` to past samples in a buffer
  ///
  /// ### Animation
  /// The default [duration] and [curve] for this `XL`'s parallax animations
  /// are controlled with these properties.
  ///
  /// This applies when the [layers] are being transformed by sensor data
  /// or are resetting/autocompensating.
  ///
  /// When [PLayer]s are actively hovered/touched, [Dragging] applies instead.
  ///
  /// ### Void Callbacks
  /// For function performance on state-change:
  /// - onPointerEnter
  /// - onPointerExit
  /// - onCompensation
  /// {@endtemplate}
  const XL({
    Key? key,
    required this.layers,
    this.sharesPointer = true,
    this.sharesSensors = false,
    this.dragging = const Dragging(),
    this.normalization = const Normalization(),
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.ease,
    this.useLocalPosition = true,
    this.referencePosition = ReferencePosition.center,
    this.onPointerEnter,
    this.onPointerExit,
    this.onCompensation,
  }) : super(key: key);

  /// A list of `XLayer`s and/or `PLayer`s to stack in this parent [XL].
  ///
  /// ### P Layers
  /// A `Layer` in an `XL`. These by themselves are not `Widget`s.
  ///
  /// Each `Layer` serves as a blueprint for transformations to its `child`
  /// within a parent `XL`, containing all the animatable properties.
  ///
  /// These `Players`s react primarily to pointer data;
  /// that is, either mouse hovers or touch inputs.
  ///
  /// ### X Layers
  /// Consider `PLayer`, but these `XLayer`s react primarily to sensors data.
  ///
  /// The `xOffset`, `yOffset`, `xRotation`, `yRotation`, and `zRotationByX`
  /// are reactionary to their respective axes when it comes to
  /// `AccelerometerEvent`s.
  ///
  /// The `zRotationByGyro`, however, is a secondary Z-axis
  /// "spin" factor whose core value is derived from `GyroscopeEvent`s.
  /// - This means that samples from the gyroscope for Z-axis "spins"
  /// with this property, according to `Normalization.samplingRate`, will spike
  /// but return to `0` immediately once the device has finished "spinning".
  final List<Widget> layers;

  /// If this `XL` has both `XLayer`s *and* `PLayer`s,
  /// `sharesPointer` set `true` will contribute both
  /// sensors data *and* pointer data toward `XLayer`s.
  ///
  /// Otherwise `XLayer`s in this `XL` are only affected by sensors data.
  ///
  /// Also see [sharesSensors].
  final bool sharesPointer;

  /// If this `XL` has both `XLayer`s *and* `PLayer`s,
  /// `sharesSensors` set `true` will contribute both
  /// sensors data *and* pointer data toward `PLayer`s.
  ///
  /// Otherwise `PLayer`s in this `XL` are only affected by pointer data.
  ///
  /// Also see [sharesPointer].
  final bool sharesSensors;

  /// A parameter class that pertains to `PLayer`s and their parallax animation
  /// during an active drag or pointer hover event.
  /// - [Dragging.resets], a flag to toggle whether layers reset on pointer exit
  /// - [Dragging.duration] of parallax animation under the pointer
  /// - [Dragging.curve] of parallax animation under the pointer
  final Dragging dragging;

  /// A parameter class for customizing the intake of `SensorEvent` data.
  /// - [Normalization.autocompensates], a flag for toggling autocompensation
  /// after steady sensor samples for some time
  /// - [Normalization.delay], how long to wait before kicking in
  /// autocompensation, considering `sensitivity` to past samples in a buffer
  /// - [Normalization.samplingRate], how frequently sensor data samples
  /// are propagated
  /// - [Normalization.sensitivity], a `double` clamped between `0..1`, that
  /// influences the maximum `List` length for a sensors data samples buffer.
  ///   - A larger `sensitivity` and thus *smaller* samples buffer means
  ///   new, strong outlier accelerometer data stands out more easily from the
  ///   average of the past samples in the buffer
  /// - [Normalization.compensation], an amount to shear from raw
  /// `AccelerometerEvent` data
  /// (`x` or `y` axis, as gyroscope is used for `z` data)
  /// - [Normalization.scalar], an amount to multiply by
  /// the calculated sensor parallax factor
  ///
  /// There is a fine balance between `sensitivity` and `samplingRate`.
  /// It is recommended to keep them default and modify `delay` as necessary.
  ///
  /// This property is ignored by `PLayer`s.
  final Normalization normalization;

  /// The default `Duration` for this `XL`'s parallax animations.
  ///
  /// This applies when the [layers] are being transformed by sensor data
  /// or are resetting/autocompensating.
  ///
  /// When [PLayer]s are actively hovered over/touched,
  /// [Dragging.duration] applies instead.
  final Duration duration;

  /// The default `Curve` for this `XL`'s parallax animations.
  ///
  /// This applies when the [layers] are being transformed by sensor data
  /// or are resetting/autocompensating.
  ///
  /// When [PLayer]s are actively hovered over/touched,
  /// [Dragging.duration] applies instead.
  final Curve curve;

  /// Whether the parallax factors for `PLayer`s should be referenced
  /// from the size and position of this [XL].
  ///
  /// If `false` the parallax for `PLayer`s in this stack
  /// will be measured based on the width and height of the screen.
  /// Otherwise it will be measured based on the size of the [XL].
  ///
  /// It is recommended to leave this `true`.
  /// This property does not affect sensors data.
  final bool useLocalPosition;

  /// From where the parallax effect should be referenced for `PLayer`s.
  /// This is a scale from `0..1`.
  ///
  /// Its default value is `0.5, 0.5`, meaning that the
  /// parallax effect is referenced from the center.
  /// This property does not affect sensors data.
  final ReferencePosition referencePosition;

  /// Provide a function to perform when this `XL`'s `MouseRegion` and
  /// `Listener` have been entered by a pointer, either mouse or touch input.
  ///
  /// This reqion is *not opaque*, and so pointer events will pass through it.
  final VoidCallback? onPointerEnter;

  /// Provide a function to perform when this `XL`'s `MouseRegion` and
  /// `Listener` have been exited by a pointer, either mouse or touch input.
  ///
  /// This reqion is *not opaque*, and so pointer events will pass through it.
  final VoidCallback? onPointerExit;

  /// Provide a function to perform when this `XL` begins one of its
  /// autocompensation steps.
  final VoidCallback? onCompensation;

  @override
  _XLState createState() => _XLState();
}

class _XLState extends State<XL> {
  double sensorFactorX = 0, sensorFactorY = 0, sensorFactorZ = 0;
  bool normalizing = false;

  double xFactor = 0, yFactor = 0;
  bool hovering = false;

  void _mapPointerEventToFactor(PointerEvent e, BoxConstraints constraints) {
    final local = widget.useLocalPosition;
    final screenSize = MediaQuery.of(context).size;
    final width = local ? constraints.maxWidth : screenSize.width;
    final height = local ? constraints.maxHeight : screenSize.height;
    final position = local ? e.localPosition : e.position;

    final factor = RelativeParallaxFactorCalculator(
      width: width,
      height: height,
      position: position,
      negative: false,
      referencePosition: widget.referencePosition,
    ).calculate();

    setState(() {
      xFactor = factor.x;
      yFactor = factor.y;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final sensorX = sensorFactorX +
        (widget.sharesPointer
            ? isPortrait
                ? xFactor
                : -yFactor
            : 0.0);
    final sensorY = sensorFactorY +
        (widget.sharesPointer
            ? isPortrait
                ? yFactor
                : xFactor
            : 0.0);
    final pointerX = xFactor +
        (widget.sharesSensors
            ? isPortrait
                ? sensorFactorX
                : sensorFactorY
            : 0.0);
    final pointerY = yFactor +
        (widget.sharesSensors
            ? isPortrait
                ? sensorFactorY
                : -sensorFactorX
            : 0.0);

    return SensorListener(
      step: widget.normalization.samplingRate,
      normalizationDelay: widget.normalization.delay,
      normalizationDuration: widget.duration * 10, // FIXME
      bufferLength: (1.0 - widget.normalization.sensitivity) * 1000,
      autocompensate: widget.normalization.autocompensates,
      compensation: widget.normalization.compensation,
      scalarX: widget.normalization.scalar.isNotEmpty
          ? widget.normalization.scalar[0]
          : 1,
      scalarY: widget.normalization.scalar.length > 1
          ? widget.normalization.scalar[1]
          : 1,
      scalarZ: widget.normalization.scalar.length > 2
          ? widget.normalization.scalar[2]
          : 1,
      sensorCallback: (xyz, normalizing) {
        widget.onCompensation?.call();
        setState(() {
          this.normalizing = normalizing;
          sensorFactorX = xyz[0];
          sensorFactorY = xyz[1];
          sensorFactorZ = xyz[2];
        });
      },
      child: PointerListener(
        onHover: _mapPointerEventToFactor,
        onEnter: (_, __) {
          widget.onPointerEnter?.call();
          setState(() => hovering = true);
        },
        onExit: (_, __) {
          widget.onPointerExit?.call();
          setState(() {
            hovering = false;
            if (widget.dragging.resets) {
              xFactor = 0.0;
              yFactor = 0.0;
            }
          });
        },
        child: AnimatedXL(
          children: widget.layers,
          xFactor: pointerX,
          yFactor: pointerY,
          sensorFactorX: isPortrait ? sensorX : sensorY,
          sensorFactorY: isPortrait ? sensorY : -sensorX,
          sensorFactorZ: sensorFactorZ,
          duration: hovering
              ? widget.dragging.duration
              : normalizing
                  ? widget.duration * 2 // FIXME
                  : widget.duration,
          curve: hovering ? widget.dragging.curve : widget.curve,
        ),
      ),
    );
  }
}
