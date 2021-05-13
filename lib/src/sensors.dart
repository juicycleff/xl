/// Defines [SensorListener] and its associated [SensorCallback].
library xl;

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:sensors_plus/sensors_plus.dart';

import 'calculation.dart';

/// {@template sensor_callback}
/// A callback used to provide a parent with computed
/// `xFactor`, `yFactor`, and `zFactor`, in that order, as a `List<double>`.
///
/// [SensorListener.sensorCallback] is invoked every [SensorListener.step].
/// {@endtemplate}
typedef SensorCallback = void Function(List<double> xyz, bool normalizing);

/// {@template sensor_listener}
/// An adaptive widget built to listen to sensor events.
/// {@endtemplate}
class SensorListener extends StatefulWidget {
  /// {@macro sensor_listener}
  const SensorListener({
    Key? key,
    required this.step,
    required this.normalizationDelay,
    required this.normalizationDuration,
    required this.bufferLength,
    required this.autocompensate,
    required this.compensation,
    required this.scalarX,
    required this.scalarY,
    required this.scalarZ,
    required this.child,
    required this.sensorCallback,
  })   : assert(
          scalarX != 0,
          '[Accelerax] > Cannot divide by 0. Provide a non-zero `scalar[0]`.',
        ),
        assert(
          scalarY != 0,
          '[Accelerax] > Cannot divide by 0. Provide a non-zero `scalar[1]`.',
        ),
        assert(
          scalarZ != 0,
          '[Accelerax] > Cannot divide by 0. Provide a non-zero `scalar[2]`.',
        ),
        super(key: key);

  /// Time between [sensorCallback] updates.
  final Duration step;

  /// Time to wait before a normalizationStep() for autocompensation.
  ///
  /// The `Stopwatch` created that uses this `Duration`
  /// will be reset may times until conditions are right.
  final Duration normalizationDelay;

  /// Time to broadcast `isNormalizing == true` after a normalizationStep()
  /// for autocompensation. Sourced from `Reset.duration`.
  final Duration normalizationDuration;

  /// How many `List<double>` entries to store in the
  /// sensor sample buffer for normalization.
  final double bufferLength;

  /// ### See `ResetSpec.shouldReset`:
  /// {@macro should_reset}
  final bool autocompensate;

  /// {@macro compensation}
  final List<double>? compensation;

  /// ### The first component for:
  /// {@macro scalar}
  final double scalarX;

  /// ### The second component for:
  /// {@macro scalar}
  final double scalarY;

  /// A `double` that corresponds to an amount that is multipied by
  /// the [GyroscopeEvent] before passing through [sensorCallback]
  /// as the output `parallaxFactor` for `AcceleraxLayer.zRotationByZ`.
  final double scalarZ;

  /// The `child` of this listener, intended to be an `AnimatedParallaxStack`.
  final Widget child;

  /// {@macro sensor_callback}
  final SensorCallback sensorCallback;

  @override
  _SensorListenerState createState() => _SensorListenerState();
}

class _SensorListenerState extends State<SensorListener> {
  double x = 0, y = 0, z = 0;
  List<double> compensation = [0.0, 0.0, 0.0];

  List<List<double>> buffer = [];
  bool isNormalizing = false;
  bool isNormalized = false;

  AccelerometerEvent accelEvent = AccelerometerEvent(0, 0, 0);
  GyroscopeEvent gyroEvent = GyroscopeEvent(0, 0, 0);
  late StreamSubscription<AccelerometerEvent> accelSubscription;
  late StreamSubscription<GyroscopeEvent> gyroSubscription;

  late Stopwatch stopwatch;
  late Timer stepTimer;

  @override
  void initState() {
    super.initState();
    initSensor();
    // autocompensationStep();
  }

  void initSensor() async {
    stopwatch = Stopwatch()..start();
    stepTimer = Timer.periodic(widget.step, (_) => step());
    accelSubscription = accelerometerEvents
        .listen((event) => setState(() => accelEvent = event));
    gyroSubscription =
        gyroscopeEvents.listen((event) => setState(() => gyroEvent = event));
  }

  void autocompensationStep() {
    compensation = [accelEvent.x, accelEvent.y];
    isNormalizing = true;
    isNormalized = false;
    Timer(widget.normalizationDuration, () {
      isNormalizing = false;
      isNormalized = true;
    });
  }

  void step() {
    if (widget.autocompensate) {
      /// So long as we should be autocompensating,
      /// also collect a running buffer of samples.
      if (buffer.length > widget.bufferLength) buffer.removeAt(0);
      buffer.add([accelEvent.x, accelEvent.y, accelEvent.z]);

      /// If the difference between the average X or Y sample in the buffer and
      /// the current X or Y sample is greater than `0.5`, the user is presumed
      /// to be actively using the sensors and not stationary for a new default.
      ///
      /// Keep resetting the stopwatch until the averages are close to
      /// the currents, such that the device has been held still for a period.
      ///
      /// Then over the next few step()s, so long as the stopwatch hasn't been
      /// reset, the `if` below will trigger a compensationStep().
      final avg = SensorCompensation.average(buffer);
      // difference greater than `0.5` arbitrarily chosen
      if (((avg[0] - accelEvent.x).abs() > 0.5) ||
          ((avg[1] - accelEvent.y).abs() > 0.5)) {
        isNormalized = false;
        stopwatch.reset();
      }

      /// If the stopwatch for compensation has not been reset,
      /// perform an autocompensationStep() and reset the stopwatch.
      if (!isNormalizing &&
          !isNormalized &&
          stopwatch.elapsed >= widget.normalizationDelay) {
        stopwatch.reset();
        autocompensationStep();
      }
    }

    // Normalize x and y values, considering provided compensation, to -1..1.
    // AccelerometerEvent.x,y,z values range from -10..10.
    x = SensorCompensation.normalize(
            accelEvent.x, compensation[0] + (widget.compensation?[0] ?? 0.0)) *
        widget.scalarX;
    y = -(SensorCompensation.normalize(
            accelEvent.y, compensation[1] + (widget.compensation?[1] ?? 0.0)) *
        widget.scalarY);

    // GyroscopeEvents come in `rad/s`, so average them for smoothness.
    // Will "teeter-totter" as it returns to zero after a spike.
    z = -gyroEvent.z.sign *
        ((gyroEvent.z.abs() + z) / 2).clamp(-1, 1) /
        widget.scalarZ;

    /// Callback with the calculated xyz parallax factors as well as
    /// the normalization status of this SensorListener.
    widget.sensorCallback(<double>[x, y, z], isNormalizing);
  }

  /// Return the child as this stateful SensorListener.
  @override
  Widget build(BuildContext context) => widget.child;

  /// Cancel timers and sensor stream subscriptions.
  @override
  void dispose() {
    stopwatch.stop();
    stepTimer.cancel();
    accelSubscription.cancel();
    gyroSubscription.cancel();
    super.dispose();
  }
}
