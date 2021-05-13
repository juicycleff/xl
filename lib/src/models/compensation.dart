/// Defines [Compensation] abstract class with static `List<double>` constants
/// for `Normalization.compensation`.
library xl;

/// A small abstract class with `static` constant `List<double>`s that refer to
/// specific device orientations according to sensor data
/// subtractions/compensations.
///
/// Providing a `Normalization.compensation` will also factor in
/// autocompensation considering `Reset.shouldReset`.
abstract class Compensation {
  /// A sensor `Compensation` that has no effect on the resultant sensor data.
  ///
  /// Recommended, along with `Reset.shouldReset == true` for autocompensation.
  static const List<double> none = [0.0, 0.0];

  /// A sensor `Compensation` that correlates to a mobile phone held
  /// vertically in portrait mode, mostly upright facing toward the user.
  static const List<double> mobilePortraitMostlyUpright = [0.0, 8.5];

  /// A sensor `Compensation` that correlates to a mobile phone held
  /// horizontally in landscape mode, mostly upright facing toward the user.
  static const List<double> mobileLandscapeMostlyUpright = [8.5, 0.0];
}
