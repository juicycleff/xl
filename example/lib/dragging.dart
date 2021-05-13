import 'package:flutter/material.dart';
import 'package:xl/xl.dart';

/// {@macro example_dragging}
class ExampleDragging extends StatelessWidget {
  /// {@template example_dragging}
  /// Two example `XL` widgets with two `PLayers`s each.
  ///
  /// Both are quite quick to "reset".
  /// One has a fast `Dragging.duration`, the other is much slower to drag.
  ///
  /// `sharesSensors` is set to`false`, so these `PLayer`s ignore sensors.
  /// On a mouseless device, test with touch.
  /// Both `XL` stacks may be interacted with simultaneously.
  /// {@endtemplate}
  const ExampleDragging({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const layers = [
      PLayer(
        dimensionalOffset: 0.005,
        xRotation: 0.35,
        yRotation: 0.35,
        zRotation: 0.25,
        xOffset: 60,
        yOffset: 60 / 2,
        child: Center(
          child: SizedBox(
            width: 300,
            height: 250,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.red),
            ),
          ),
        ),
      ),
      PLayer(
        dimensionalOffset: 0.0025,
        xRotation: 0.6,
        yRotation: 0.4,
        zRotation: 0.3,
        xOffset: 125,
        yOffset: 125 / 2,
        child: Center(
          child: SizedBox(
            width: 200,
            height: 200,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.amber,
                boxShadow: [BoxShadow(blurRadius: 20, spreadRadius: -6)],
              ),
            ),
          ),
        ),
      ),
    ];

    return Scaffold(
      body: Column(
        children: [
          const Flexible(
            child: XL(
              // `PLayer`s will respond only to pointer data
              sharesSensors: false,
              // Duration for "dragging"
              dragging: Dragging(duration: Duration(milliseconds: 100)),
              // Duration for "resetting"
              duration: Duration(milliseconds: 300),
              layers: layers,
            ),
          ),
          const Flexible(
            child: XL(
              sharesSensors: false,
              dragging: Dragging(duration: Duration(milliseconds: 500)),
              duration: Duration(milliseconds: 300),
              layers: layers,
            ),
          ),
        ],
      ),
    );
  }
}
