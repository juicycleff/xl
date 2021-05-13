import 'package:flutter/material.dart';
import 'package:xl/xl.dart';

/// {@macro example_delay}
class ExampleDelay extends StatelessWidget {
  /// {@template example_delay}
  /// The large, upper `XL` does not autocompensate, but it is pre-compensated
  /// with a value that approximates a mobile held portrait toward the face.
  ///
  /// The bottom two rows of two `XL` each have increasingly longer
  /// `Normalization.delay` Durations, as they *do* autocompensate.
  ///
  /// Primarily an accelerometer demo.
  /// {@endtemplate}
  const ExampleDelay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            const Flexible(
              child: XL(
                dragging: Dragging(resets: false),
                normalization: Normalization(
                  autocompensates: false,
                  compensation: Compensation.mobilePortraitMostlyUpright,
                ),
                layers: [
                  XLayer(
                    dimensionalOffset: 0.005,
                    xRotation: 0.35 * 5,
                    yRotation: 0.35 * 5,
                    zRotationByX: 0.25 * 5,
                    xOffset: 60 * 5,
                    yOffset: 60 / 2 * 5,
                    child: Center(
                      child: SizedBox(
                        width: 300,
                        height: 250,
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: Colors.brown),
                        ),
                      ),
                    ),
                  ),
                  XLayer(
                    dimensionalOffset: 0.0025,
                    xRotation: 0.6 * 5,
                    yRotation: 0.4 * 5,
                    zRotationByX: 0.3 * 5,
                    xOffset: 125 * 5,
                    yOffset: 125 / 2 * 5,
                    child: Center(
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.deepOrangeAccent,
                            boxShadow: [
                              BoxShadow(blurRadius: 20, spreadRadius: -6)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  XLayer(
                    dimensionalOffset: 0.002,
                    xRotation: 0.7 * 5,
                    yRotation: 0.45 * 5,
                    zRotationByX: 0.4 * 5,
                    xOffset: 225 * 5,
                    yOffset: 225 / 2 * 5,
                    child: Center(
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                            boxShadow: [
                              BoxShadow(blurRadius: 20, spreadRadius: -6)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Row(
                children: [
                  const Flexible(
                    child: XL(
                      duration: Duration(milliseconds: 100),
                      dragging: Dragging(duration: Duration(milliseconds: 100)),
                      normalization:
                          Normalization(delay: Duration(milliseconds: 500)),
                      layers: [
                        XLayer(
                          dimensionalOffset: 0.005,
                          xRotation: 0.35 * 5,
                          yRotation: 0.35 * 5,
                          zRotationByX: 0.25 * 5,
                          xOffset: 60,
                          yOffset: 60 / 2,
                          child: Center(
                            child: SizedBox(
                              width: 300 / 1.5,
                              height: 250 / 1.5,
                              child: DecoratedBox(
                                decoration:
                                    BoxDecoration(color: Colors.deepPurple),
                              ),
                            ),
                          ),
                        ),
                        XLayer(
                          dimensionalOffset: 0.0025,
                          xRotation: 0.6 * 5,
                          yRotation: 0.4 * 5,
                          zRotationByX: 0.3 * 5,
                          xOffset: 125 * 5,
                          yOffset: 125 / 2 * 5,
                          child: Center(
                            child: SizedBox(
                              width: 180 / 1.5,
                              height: 180 / 1.5,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.purple,
                                  boxShadow: [
                                    BoxShadow(blurRadius: 20, spreadRadius: -6)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        XLayer(
                          dimensionalOffset: 0.002,
                          xRotation: 0.7 * 5,
                          yRotation: 0.45 * 5,
                          zRotationByX: 0.4 * 5,
                          xOffset: 225 * 5,
                          yOffset: 225 / 2 * 5,
                          child: Center(
                            child: SizedBox(
                              width: 100 / 1.5,
                              height: 100 / 1.5,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.purpleAccent,
                                  boxShadow: [
                                    BoxShadow(blurRadius: 20, spreadRadius: -6)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Flexible(
                    child: XL(
                      duration: Duration(milliseconds: 200),
                      dragging: Dragging(duration: Duration(milliseconds: 200)),
                      normalization:
                          Normalization(delay: Duration(milliseconds: 1000)),
                      layers: [
                        XLayer(
                          dimensionalOffset: 0.005,
                          xRotation: 0.35 * 5,
                          yRotation: 0.35 * 5,
                          zRotationByX: 0.25 * 5,
                          xOffset: 60 * 5,
                          yOffset: 60 / 2 * 5,
                          child: Center(
                            child: SizedBox(
                              width: 300 / 1.5,
                              height: 250 / 1.5,
                              child: DecoratedBox(
                                decoration: BoxDecoration(color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                        XLayer(
                          dimensionalOffset: 0.0025,
                          xRotation: 0.6 * 5,
                          yRotation: 0.4 * 5,
                          zRotationByX: 0.3 * 5,
                          xOffset: 125 * 5,
                          yOffset: 125 / 2 * 5,
                          child: Center(
                            child: SizedBox(
                              width: 180 / 1.5,
                              height: 180 / 1.5,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  boxShadow: [
                                    BoxShadow(blurRadius: 20, spreadRadius: -6)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        XLayer(
                          dimensionalOffset: 0.002,
                          xRotation: 0.7 * 5,
                          yRotation: 0.45 * 5,
                          zRotationByX: 0.4 * 5,
                          xOffset: 225 * 5,
                          yOffset: 225 / 2 * 5,
                          child: Center(
                            child: SizedBox(
                              width: 100 / 1.5,
                              height: 100 / 1.5,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.amberAccent,
                                  boxShadow: [
                                    BoxShadow(blurRadius: 20, spreadRadius: -6)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Row(
                children: [
                  const Flexible(
                    child: XL(
                      duration: Duration(milliseconds: 400),
                      dragging: Dragging(duration: Duration(milliseconds: 400)),
                      normalization:
                          Normalization(delay: Duration(milliseconds: 2500)),
                      layers: [
                        XLayer(
                          dimensionalOffset: 0.005,
                          xRotation: 0.35 * 5,
                          yRotation: 0.35 * 5,
                          zRotationByX: 0.25 * 5,
                          xOffset: 60 * 5,
                          yOffset: 60 / 2 * 5,
                          child: Center(
                            child: SizedBox(
                              width: 300 / 1.5,
                              height: 250 / 1.5,
                              child: DecoratedBox(
                                decoration: BoxDecoration(color: Colors.blue),
                              ),
                            ),
                          ),
                        ),
                        XLayer(
                          dimensionalOffset: 0.0025,
                          xRotation: 0.6 * 5,
                          yRotation: 0.4 * 5,
                          zRotationByX: 0.3 * 5,
                          xOffset: 125 * 5,
                          yOffset: 125 / 2 * 5,
                          child: Center(
                            child: SizedBox(
                              width: 180 / 1.5,
                              height: 180 / 1.5,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  boxShadow: [
                                    BoxShadow(blurRadius: 20, spreadRadius: -6)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        XLayer(
                          dimensionalOffset: 0.002,
                          xRotation: 0.7 * 5,
                          yRotation: 0.45 * 5,
                          zRotationByX: 0.4 * 5,
                          xOffset: 225 * 5,
                          yOffset: 225 / 2 * 5,
                          child: Center(
                            child: SizedBox(
                              width: 100 / 1.5,
                              height: 100 / 1.5,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.lightGreen,
                                  boxShadow: [
                                    BoxShadow(blurRadius: 20, spreadRadius: -6)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Flexible(
                    child: XL(
                      duration: Duration(milliseconds: 600),
                      dragging: Dragging(duration: Duration(milliseconds: 600)),
                      normalization:
                          Normalization(delay: Duration(milliseconds: 5000)),
                      layers: [
                        XLayer(
                          dimensionalOffset: 0.005,
                          xRotation: 0.35 * 5,
                          yRotation: 0.35 * 5,
                          zRotationByX: 0.25 * 5,
                          xOffset: 60 * 5,
                          yOffset: 60 / 2 * 5,
                          child: Center(
                            child: SizedBox(
                              width: 300 / 1.5,
                              height: 250 / 1.5,
                              child: DecoratedBox(
                                decoration: BoxDecoration(color: Colors.cyan),
                              ),
                            ),
                          ),
                        ),
                        XLayer(
                          dimensionalOffset: 0.0025,
                          xRotation: 0.6 * 5,
                          yRotation: 0.4 * 5,
                          zRotationByX: 0.3 * 5,
                          xOffset: 125 * 5,
                          yOffset: 125 / 2 * 5,
                          child: Center(
                            child: SizedBox(
                              width: 180 / 1.5,
                              height: 180 / 1.5,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.greenAccent,
                                  boxShadow: [
                                    BoxShadow(blurRadius: 20, spreadRadius: -6)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        XLayer(
                          dimensionalOffset: 0.002,
                          xRotation: 0.7 * 5,
                          yRotation: 0.45 * 5,
                          zRotationByX: 0.4 * 5,
                          // zRotationByGyro: 2,
                          xOffset: 225 * 5,
                          yOffset: 225 / 2 * 5,
                          child: Center(
                            child: SizedBox(
                              width: 100 / 1.5,
                              height: 100 / 1.5,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.deepPurpleAccent,
                                  boxShadow: [
                                    BoxShadow(blurRadius: 20, spreadRadius: -6)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
