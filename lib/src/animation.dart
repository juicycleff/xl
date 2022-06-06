/// Defines [AnimatedXL], penultimate widget prior to end products.
library xl;

import 'package:flutter/material.dart';

import 'rendering.dart';

/// {@template animated_xl}
/// An [ImplicitlyAnimatedWidget] to animate the values of an `XL`.
/// {@endtemplate}
class AnimatedXL extends ImplicitlyAnimatedWidget {
  /// {@macro animated_xl}
  const AnimatedXL({
    Key? key,
    this.xFactor = 0,
    this.yFactor = 0,
    this.sensorFactorX = 0,
    this.sensorFactorY = 0,
    this.sensorFactorZ = 0,
    required this.children,
    required Duration duration,
    Curve curve = Curves.linear,
  }) : super(key: key, duration: duration, curve: curve);

  /// A list of `Layer`s.
  ///
  /// ### X Layers
  /// {@macro xlayer}
  ///
  /// ### P Layers
  /// {@macro player}
  final List<Widget> children;

  /// {@template pointer_factor}
  /// The distance the mouse has moved across this axis
  /// represented by a range of values from `-1` to `1`.
  /// {@endtemplate}
  final double xFactor;

  /// {@macro pointer_factor}
  final double yFactor;

  /// {@template sensor_factor}
  /// Only pertinent for `Accelerax` widgets.
  ///
  /// The amount the device has rotated in this axis
  /// represented by a range of values from `-1` to `1`.
  /// {@endtemplate}
  final double sensorFactorX;

  /// {@macro sensor_factor}
  final double sensorFactorY;

  /// {@macro sensor_factor}
  final double sensorFactorZ;

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _AnimatedXLState();
}

class _AnimatedXLState extends AnimatedWidgetBaseState<AnimatedXL> {
  Tween<double>? _xFactor, _yFactor;
  Tween<double>? _sensorFactorX, _sensorFactorY, _sensorFactorZ;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _xFactor = visitor(_xFactor, widget.xFactor,
        (dynamic e) => Tween<double>(begin: e as double)) as Tween<double>;
    _yFactor = visitor(_yFactor, widget.yFactor,
        (dynamic e) => Tween<double>(begin: e as double)) as Tween<double>;
    _sensorFactorX = visitor(_sensorFactorX, widget.sensorFactorX,
        (dynamic e) => Tween<double>(begin: e as double)) as Tween<double>;
    _sensorFactorY = visitor(_sensorFactorY, widget.sensorFactorY,
        (dynamic e) => Tween<double>(begin: e as double)) as Tween<double>;
    _sensorFactorZ = visitor(_sensorFactorZ, widget.sensorFactorZ,
        (dynamic e) => Tween<double>(begin: e as double)) as Tween<double>;
  }

  @override
  Widget build(BuildContext context) => StaticXL(
        xFactor: _xFactor?.evaluate(animation) ?? 0.0,
        yFactor: _yFactor?.evaluate(animation) ?? 0.0,
        sensorFactorX: _sensorFactorX?.evaluate(animation) ?? 0.0,
        sensorFactorY: _sensorFactorY?.evaluate(animation) ?? 0.0,
        sensorFactorZ: _sensorFactorZ?.evaluate(animation) ?? 0.0,
        children: widget.children,
      );
}
