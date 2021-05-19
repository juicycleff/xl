/// Defines [Normalization] parameter object for `XLayer`s.
library xl;

import '../models/compensation.dart';

/// {@macro normalization}
class Normalization {
  /// {@template normalization}
  /// A parameter class that primarily pertain to `XLayer`s
  /// for customizing the intake of `SensorEvent` data.
  /// - **[autocompensates]**, a flag for toggling autocompensation after
  ///   steady sensor samples for some time
  /// - **[delay]**, how long to wait before kicking in autocompensation,
  ///   considering [sensitivity] to past samples in a buffer
  /// - **[compensation]**, an amount to shear from raw `AccelerometerEvent`
  ///   data (`x` or `y` axis, as gyroscope is used for `z` data)
  /// - **[scalar]**, an amount to multiply by the calculated
  ///   sensor parallax factor
  /// - **[samplingRate]**, how frequently sensor data samples are propagated
  /// - **[sensitivity]**, a `double` clamped between `0..1`, that influences
  ///   the maximum `List` length for a sensors data samples buffer.
  ///   - A larger `sensitivity` and thus *smaller* samples buffer means
  ///     new, strong outlier accelerometer data stands out more easily from the
  ///     average of the past samples in the buffer
  ///
  /// ### ❗ *NOTE:*
  /// There is a fine balance between `sensitivity` and `samplingRate`.
  /// It is recommended to keep them default and modify `delay` as necessary.
  /// {@endtemplate}
  const Normalization({
    this.autocompensates = true,
    this.delay = const Duration(milliseconds: 1000),
    this.compensation = Compensation.none,
    this.scalar = const [1.0, 1.0, 1.0],
    this.samplingRate = const Duration(milliseconds: 10),
    this.sensitivity = 0.9,
  }) : assert(sensitivity >= 0 && sensitivity <= 1);

  /// Should these sensor samples be autocompensated? That is, with our
  /// without a supplied [compensation], should values generate
  /// dynamically for the `compensation` that is subtracted
  /// from sensor samplings?
  ///
  /// Default is `true`. Otherwise an `XL` will only consider
  /// [compensation], which defaults to `[0,0]`
  /// (respectively `[x,y]`).
  final bool autocompensates;

  /// {@template delay}
  /// A `Duration` that represents how long to wait before kicking
  /// autocompensation into play. Default is `1000ms`.
  ///
  /// Consider [sensitivity]. So long as the sensors data samples coming in
  /// are close enough to the average of the buffer (whose size is determined
  /// by `sensitivity`), this `normalizationDelay` will be continually reset.
  ///
  /// Once the current samples differ from the average samples from the buffer
  /// non-negligibly, and then after this `normalizationDelay` has passed,
  /// an autocompensation factor is applied.
  /// {@endtemplate}
  final Duration delay;

  /// {@template compensation}
  /// A `List<double>` ordered `[x,y]` that corresponds to an amount
  /// that gets shaved from each raw `AccelerometerEvent`, sampled at
  /// [samplingRate], to compensate for a device being held in a "standard"
  /// position for some time.
  ///
  /// If `Reset.shouldReset` is `true`,
  /// this `compensation` is applied in addition.
  ///
  /// This "compensated" sensor data may differ from, say, raw `y` output
  /// which is `0` only when the device is flat on its back on a surface.
  ///
  /// The default is `[0, 0]` which corresponds to no compensation
  /// for the X-axis nor Y-axis readings.
  /// `Compensation.none` applies a `const [0,0]` compensation.
  ///
  /// An initialization around `Compensation.mobilePortraitMostlyUpright`
  /// (`[0, 8.5]`) roughly correlates to a mobile phone that is held upright,
  /// portrait mode toward a user's face.
  /// {@endtemplate}
  final List<double> compensation;

  /// {@template scalar}
  /// A `List<double>` ordered `[x,y,z]` that corresponds to an amount
  /// that is multiplied to the  `SensorEvent` before output as parallax factor.
  ///
  /// [compensation]ed, if `AccelerometerEvent` (`x` or `y`), before [scalar].
  /// {@endtemplate}
  final List<double> scalar;

  /// {@template sampling_rate}
  /// A `Duration` that represents how frequently new sensor samples occur.
  ///
  /// A more frequent `samplingRate` will result in a more *accurate*
  /// sampling, but because many devices with accelerometers are mobiles
  /// held in the hand, the result may be "shaky".
  ///
  /// Default is `10ms`, a time much shorter than the default `Duration` of
  /// animation for `XL.drag`, which is `500ms`.
  ///
  /// Consider a [sensitivity] buffer that correlates with this `samplingRate`.
  /// A slow `samplingRate` would not necessitate a large buffer, so a
  /// smaller `sensitivity` would suffice.
  /// {@endtemplate}
  final Duration samplingRate;

  /// {@template sensitivity}
  /// How "sensitive" this `Normalization` should be as an `double`.
  /// Clamped between `0..1`.
  ///
  /// Influences the size of a buffer that stores past sensor samples.
  /// That is to say, this `sensitivity` is subtracted from `1.0`, then the
  /// result is multiplied by `1000` and used as the maximum `List` length
  /// for a sensor samples buffer.
  ///
  /// `sensitivity` | `calculation` | `buffer length`
  /// - `1.0` => `(1.0 - 1.0) * 1000` = `0`
  /// - `0.9` => `(1.0 - 0.9) * 1000` = `100` (default)
  /// - `0.0` => `(1.0 - 0.0) * 1000` = `1000`
  ///
  /// A larger `sensitivity`, and thus *smaller* samples buffer means
  /// new, strong outlier accelerometer data stands out more easily from the
  /// average of the past samples in the buffer.
  /// This will cause autocompensation on `AcceleraxLayer`s (or `XLayer`s)
  /// to kick in more easily, delayed by a wait for [delay] `Duration`.
  ///
  /// A smaller `sensitivity` also increases the size of an internal
  /// `List<List<double>>` buffer, so consider memory consumption.
  ///
  /// Default is `0.9` for a buffer `List` length of `100`.
  /// With `sensitivity == 1.0`, autocompensation would
  /// consistently occur every [delay] `Duration`.
  /// {@endtemplate}
  final double sensitivity;
}
