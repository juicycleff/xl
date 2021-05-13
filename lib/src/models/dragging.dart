/// Defines [Dragging] parameter object for `PLayer`s.
library xl;

import 'package:flutter/animation.dart';

/// {@macro dragging}
class Dragging {
  /// {@template dragging}
  /// A parameter class that pertains to `PLayer`s and their parallax animation
  /// during an active drag or pointer hover event.
  /// - [resets], a flag to toggle whether layers reset on pointer exit
  /// - [duration] of parallax animation under the pointer
  /// - [curve] of parallax animation under the pointer
  /// {@endtemplate}
  const Dragging({
    this.resets = true,
    this.duration = const Duration(milliseconds: 100),
    this.curve = Curves.ease,
  });

  /// Whether `PLayer`s within an `XL.layers` stack should reset
  /// to their default position when the pointer leaves their hover region.
  ///
  /// Default is `true`.
  final bool resets;

  /// The `Duration` of the animation that takes place when pointer
  /// or sensors data events occur, and so when the widget transforms
  /// under the pointer.
  ///
  /// Default is `100ms`.
  final Duration duration;

  /// The `Curve` of the animation that takes place when pointer
  /// or sensors data events occur, and so when the widget transforms
  /// under the pointer.
  ///
  /// Default is `Curves.ease`.
  final Curve curve;
}
