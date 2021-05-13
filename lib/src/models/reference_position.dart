/// Defines [ReferencePosition] wrapper for `x, y` between `0..1`.
library xl;

/// {@macro reference_position}
class ReferencePosition {
  /// {@template reference_position}
  /// A simple wrapper for the `x` & `y` values of the
  /// `XL`'s reference position as doubles between `0..1`.
  /// {@endtemplate}
  const ReferencePosition(this.x, this.y)
      : assert(
          x >= 0 && x <= 1 && y >= 0 && y <= 1,
          'The reference position must be between or equal to zero and one',
        );

  /// A `ReferencePosition` whose `x` and `y` values are both `0.5`,
  /// referring to the center of a viewport.
  static const center = ReferencePosition(0.5, 0.5);

  /// The reference position on the `x` axis. By default, it is set to `0.5`.
  final double x;

  /// The reference position on the `y` axis. By default, it is set to `0.5`.
  final double y;
}
