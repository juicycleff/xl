/// Defines [PointerListener] and its associated [HoverConstraintCallback].
library xl;

import 'package:flutter/material.dart';

/// A callback used to provide the parent with
/// details of the current local pointer event.
typedef HoverConstraintCallback = void Function(
  PointerEvent hoverEvent,
  BoxConstraints constraints,
);

/// {@template pointer_listener}
/// An adaptive widget built to listen to pointer events
/// {@endtemplate}
class PointerListener extends StatelessWidget {
  /// {@macro pointer_listener}
  const PointerListener({
    Key? key,
    required this.child,
    required this.onEnter,
    required this.onExit,
    required this.onHover,
  }) : super(key: key);

  /// Triggered when a pointer has entered this widget.
  final HoverConstraintCallback onEnter;

  /// Triggered when a pointer has exited this widget.
  final HoverConstraintCallback onExit;

  /// Triggered when a pointer hovers over this widget.
  final HoverConstraintCallback onHover;

  /// The child of this listener, intended to be an `AnimatedParallaxStack`.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    late Widget listener;

    return LayoutBuilder(builder: (context, constraints) {
      listener = MouseRegion(
        opaque: false, // expose flag?
        onHover: (e) => onHover(e, constraints),
        onEnter: (e) => onEnter(e, constraints),
        onExit: (e) => onExit(e, constraints),
        child: Listener(
          onPointerMove: (e) => onHover(e, constraints),
          onPointerDown: (e) => onEnter(e, constraints),
          onPointerUp: (e) => onExit(e, constraints),
          child: child,
        ),
      );

      return listener;
    });
  }
}
