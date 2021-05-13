import 'package:flutter/material.dart';
import 'package:xl/xl.dart';

/// {@macro example_stack}
class ExampleStack extends StatelessWidget {
  /// {@template example_stack}
  /// These two `XL`s stacked on one another are similar but
  /// the top layer reacts more strongly. They are interacted with
  /// simultaneously and fluidly as an extension of pointer/sensors data.
  ///
  /// Neither stack will "reset" after they have been touched/hovered over,
  /// as per `Dragging(resets: false)`, but they will still autocompensate to
  /// steady sensors data after the default `Normalization.delay` of 1 second.
  /// {@endtemplate}
  const ExampleStack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: [
            const XL(
              dragging: Dragging(
                resets: false,
                duration: Duration(milliseconds: 100),
              ),
              duration: Duration(milliseconds: 400),
              layers: [
                XLayer(
                  dimensionalOffset: 0.005,
                  xRotation: 0.35,
                  yRotation: 0.35,
                  zRotationByX: 0.25,
                  xOffset: 60,
                  yOffset: 60 / 2,
                  child: Align(
                    alignment: Alignment(0, 0),
                    child: SizedBox(
                      width: 300,
                      height: 250,
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: Colors.amberAccent),
                      ),
                    ),
                  ),
                ),
                XLayer(
                  dimensionalOffset: 0.0025,
                  xRotation: 0.6,
                  yRotation: 0.4,
                  zRotationByX: 0.3,
                  xOffset: 125,
                  yOffset: 125 / 2,
                  child: Align(
                    alignment: Alignment(-0.5, -0.5),
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 20,
                              spreadRadius: -6,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                XLayer(
                  dimensionalOffset: 0.0025,
                  xRotation: 0.6,
                  yRotation: 0.4,
                  zRotationByX: 0.3,
                  xOffset: 125,
                  yOffset: 125 / 2,
                  child: Align(
                    alignment: Alignment(0.5, 0.5),
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 20,
                              spreadRadius: -6,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const XL(
              dragging: Dragging(
                resets: false,
                duration: Duration(milliseconds: 100),
              ),
              duration: Duration(milliseconds: 400),
              layers: [
                XLayer(
                  dimensionalOffset: 0.005,
                  xRotation: 0.6 * 2,
                  yRotation: 0.4 * 1.5,
                  zRotationByX: 0.3 * 2,
                  xOffset: 125 * 2,
                  yOffset: 125 / 2 * 2,
                  child: Align(
                    alignment: Alignment(0, 0.5),
                    child: SizedBox(
                      width: 300 / 4,
                      height: 250 / 4,
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: Colors.lightBlue),
                      ),
                    ),
                  ),
                ),
                XLayer(
                  dimensionalOffset: 0.005,
                  xRotation: 0.6 * 2,
                  yRotation: 0.4 * 1.5,
                  zRotationByX: 0.3 * 2,
                  xOffset: 125 * 2,
                  yOffset: 125 / 2 * 2,
                  child: Align(
                    alignment: Alignment(0, -0.5),
                    child: SizedBox(
                      width: 300 / 4,
                      height: 250 / 4,
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: Colors.lightBlue),
                      ),
                    ),
                  ),
                ),
                XLayer(
                  dimensionalOffset: 0.0025,
                  xRotation: 0.6 * 2,
                  yRotation: 0.4 * 1.5,
                  zRotationByX: 0.3 * 2,
                  xOffset: 125 * 2,
                  yOffset: 125 / 2 * 2,
                  child: Align(
                    alignment: Alignment(-0.75, -0.75),
                    child: SizedBox(
                      width: 200 / 2,
                      height: 200 / 2,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 20,
                              spreadRadius: -6,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                XLayer(
                  dimensionalOffset: 0.0025,
                  xRotation: 0.6 * 2,
                  yRotation: 0.4 * 1.5,
                  zRotationByX: 0.3 * 2,
                  xOffset: 125 * 2,
                  yOffset: 125 / 2 * 2,
                  child: Align(
                    alignment: Alignment(0.75, 0.75),
                    child: SizedBox(
                      width: 200 / 2,
                      height: 200 / 2,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 20,
                              spreadRadius: -6,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
