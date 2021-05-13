/// Defines an abstract and concrete [RelativeParallaxFactorCalculator] that
/// utilizes a defined [ParallaxFactor],
/// {@macro parallax_factor}
///
/// Defines an abstract [SensorCompensation] class with a few static methods
/// to aid `SensorListener`.
library xl;

import 'dart:ui';

import 'package:flutter/material.dart';

import 'models/reference_position.dart';

/// {@macro parallax_factor}
class ParallaxFactor {
  /// {@template parallax_factor}
  /// A wrapper for the calculated `x` & `y` factors of parallax events.
  /// {@endtemplate}
  ParallaxFactor(this.x, this.y);

  /// The generated `x` reference. When [ReferencePosition.x] is `0.5`,
  /// it is between `-1.0` and `1.0`,
  final double x;

  /// The generated `y` reference. When [ReferencePosition.y] is `0.5`,
  /// it is between `-1.0` and `1.0`,
  final double y;
}

/// A calculator used to generate parallax factor values.
abstract class ParallaxFactorCalculator {
  /// A calculator used to generate parallax factor values.
  ParallaxFactorCalculator({
    required this.width,
    required this.height,
    required this.referencePosition,
    required this.position,
  });

  /// Used to calculate the necessary parallax factor.
  ParallaxFactor calculate();

  /// The width of the screen
  final double width;

  /// The height of the screen
  final double height;

  /// The reference position of the screen
  final ReferencePosition referencePosition;

  /// The position of the cursor.
  final Offset position;
}

/// A calculator for reference positions between `-1` and `1`.
class RelativeParallaxFactorCalculator implements ParallaxFactorCalculator {
  /// A calculator for reference positions between `-1` and `1`.
  const RelativeParallaxFactorCalculator({
    required this.width,
    required this.height,
    required this.position,
    this.negative = true,
    this.referencePosition = const ReferencePosition(0.5, 0.5),
  });

  @override
  final double width;
  @override
  final double height;
  @override
  final ReferencePosition referencePosition;
  @override
  final Offset position;

  /// Whether the value should be negated.
  final bool negative;

  @override
  ParallaxFactor calculate() {
    final referenceWidth = width * referencePosition.x;
    final referenceHeight = height * referencePosition.y;

    final relativeX = ((referenceWidth - position.dx) / width) * 2;
    final relativeY = ((referenceHeight - position.dy) / height) * 2;

    if (negative) {
      return ParallaxFactor(-relativeX, -relativeY);
    } else {
      return ParallaxFactor(relativeX, relativeY);
    }
  }
}

/// An abstract class with static methods to handle sensor samples.
abstract class SensorCompensation {
  /// Consider a growing, passed `List<List<double>>` called buffer
  /// of previous `SensorEvent` samples and return a condensed `List<double>`
  /// that contais their averages.
  static List<double> average(List<List<double>> buffer) {
    var avgX = 0.0, avgY = 0.0, avgZ = 0.0;
    for (final sample in buffer) {
      avgX += sample[0];
      avgY += sample[1];
      avgZ += sample.length < 3 ? sample[1] : sample[2];
    }
    final bufferLength = buffer.length;
    avgX /= bufferLength;
    avgY /= bufferLength;
    avgZ /= bufferLength;
    return [avgX, avgY, avgZ];
  }

  /// Normalize `x` and `y` values, considering provided compensation, to -1..1.
  ///
  /// AccelerometerEvent.x,y values range from -10..10.
  static double normalize(double sample, double compensation) =>
      2 * ((sample - compensation + 10) / 20) - 1;

  /// Consider difference between the average [xy] in [buffer] and last [xy]
  /// in [buffer] and return a "strength" between `0..1`
  /// to apply to the sample compensation.
  static double strength(List<List<double>> buffer, int xy) {
    final strength = 1.0 -
        (average(buffer)[xy] -
                (buffer.isEmpty
                        ? average(buffer)[xy]
                        : buffer[buffer.length - 1][xy])
                    .abs())
            .clamp(0, 1);
    // print(strength);
    return strength;
  }
}
