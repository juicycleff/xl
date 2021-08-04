import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:xl/xl.dart';
import 'package:foil/foil.dart';

// ignore: unused_import
import 'delay.dart';
// ignore: unused_import
import 'dragging.dart';
// ignore: unused_import
import 'stack.dart';

void main() => runApp(const Example());

/// {@macro example}
class Example extends StatelessWidget {
  /// {@template example}
  /// Example parallax app utilizing the `XL` stack widget.
  /// Several demos are available.
  /// {@endtemplate}
  const Example({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>

      /// Comment `ExampleXL` line and uncomment another demo line ([CTRL] + [/])
      // const MaterialApp(color: Colors.black, home: Logotype());
      // const MaterialApp(color: Colors.white, home: Example0());
      // const MaterialApp(color: Colors.white, home: ExampleDragging());
      // const MaterialApp(color: Colors.white, home: ExampleStack());
      // const MaterialApp(color: Colors.white, home: ExampleDelay());
      // const MaterialApp(color: Colors.white, home: ExampleSharingInput());
      const MaterialApp(color: Colors.black, home: ExampleStarfield());
  // const MaterialApp(color: Colors.black, home: Automation());
}

/// {@macro logotype}
class Logotype extends StatelessWidget {
  /// {@template logotype}
  /// A spinning "top" made of the XL package logotype.
  /// {@endtemplate}
  const Logotype({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: XL(
        // useLocalPosition: false,
        layers: [
          XLayer(
            xOffset: 500,
            yOffset: 500,
            yRotation: 50,
            xRotation: 1,
            child: Center(
              child: Image(
                image: const AssetImage('res/xl.png'),
                width: 475 / (MediaQuery.of(context).devicePixelRatio / 2),
                height: 214 / (MediaQuery.of(context).devicePixelRatio / 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// {@macro example0}
class Example0 extends StatelessWidget {
  /// {@template example0}
  /// A simple `XL` example with two layers.
  ///
  /// This widget reacts to pointer/touch and to sensors data.
  /// {@endtemplate}
  const Example0({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: XL(
          layers: [
            XLayer(
                xRotation: 1.0,
                yRotation: 1.0,
                xOffset: 200,
                yOffset: 200,
                child: Center(
                    child: Container(
                  width: 250,
                  height: 250,
                  color: Colors.black,
                ))),
            XLayer(
                xRotation: 1.5,
                yRotation: 1.5,
                xOffset: 300,
                yOffset: 300,
                child: Center(
                    child: Container(
                  width: 175,
                  height: 175,
                  color: Colors.red,
                ))),
          ],
        ),
      ),
    );
  }
}

/// {@macro automation}
class Automation extends StatelessWidget {
  /// {@template automation}
  /// Generation of `XL` widgets & also presets.
  /// {@endtemplate}
  const Automation({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final cyans = List.generate(4, (i) => Colors.cyan[((1 + 2 * i) * 100)]);
    final purples = List.generate(4, (i) => Colors.purple[((1 + 2 * i) * 100)]);
    final pinks = List.generate(4, (i) => Colors.pink[((1 + 2 * i) * 100)]);

    List<Widget> buildLayers(int i) => [
          Container(
            width: 200.0,
            height: 200.0,
            color: purples[i],
          ),
          Container(
            width: 200.0,
            height: 200.0,
            color: pinks[i],
          ),
        ];

    final autoXLs = [
      AutoXL.pane(layers: buildLayers(0)),
      AutoXL.wiggler(layers: buildLayers(1)),
      AutoXL.deep(layers: buildLayers(2)),
      AutoXL(
        depthFactor: 100, // only accepted by default `AutoXL()`
        layers: buildLayers(3),
      ),
    ];

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.amber.shade100,
        body: Center(
          child: Wrap(
            children: [
              for (var i = 0; i <= 3; i++)
                Container(
                  width: 200.0,
                  height: 200.0,
                  color: cyans[i],
                  child: Center(child: autoXLs[i]),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// {@macro example_sharing}
class ExampleSharingInput extends StatelessWidget {
  /// {@template example_sharing}
  /// Four example `XL` widgets with both an `XLayer` and
  /// `PLayer` with no autocompensation & alternating input flags.
  ///
  /// Two flags for four total configurations.
  ///
  /// - 🟥 Red layers are `PLayer`s and react primarily to pointers data.
  ///   - 👈 The left two 🟥 `PLayer`s also consider sensors data
  ///
  /// - 🟦 Blue layers are `XLayer`s and react primarily to sensors data.
  ///   - 👆 The top two 🟦 `XLayer`s also consider pointer data
  ///
  /// - ⬛ Black layers are control `XLayer`s with *no animation properties*.
  /// They make no reaction to any input.
  ///
  /// {@endtemplate}
  const ExampleSharingInput({Key? key}) : super(key: key);

  static const _layers = <PLayer>[
    XLayer(
      dimensionalOffset: 0.002,
      xRotation: 0.75,
      yRotation: 0.5,
      zRotationByX: 0.5,
      xOffset: 60,
      yOffset: 60,
      child: Center(
        child: SizedBox(
          width: 230,
          height: 350,
          child: DecoratedBox(decoration: BoxDecoration(color: Colors.blue)),
        ),
      ),
    ),
    PLayer(
      dimensionalOffset: 0.0015,
      xRotation: 1,
      yRotation: 1,
      zRotation: 1,
      xOffset: 125,
      yOffset: 125,
      child: Center(
        child: SizedBox(
          width: 150,
          height: 200,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.red,
              boxShadow: [BoxShadow(blurRadius: 20, spreadRadius: -6)],
            ),
          ),
        ),
      ),
    ),
    XLayer(
      child: Center(
        child: SizedBox(
          width: 75,
          height: 75,
          child: DecoratedBox(decoration: BoxDecoration(color: Colors.black)),
        ),
      ),
    )
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            Expanded(
                child: Row(children: [
              const Expanded(
                  child: XL(
                sharesPointer: true,
                sharesSensors: true,
                layers: _layers,
              )),
              const Expanded(
                  child: XL(
                sharesPointer: true, // default
                sharesSensors: false, // default
                layers: _layers,
              ))
            ])),
            Expanded(
                child: Row(children: [
              const Expanded(
                  child: XL(
                sharesPointer: false,
                sharesSensors: true,
                layers: _layers,
              )),
              const Expanded(
                  child: XL(
                sharesPointer: false,
                sharesSensors: false,
                layers: _layers,
              ))
            ])),
          ],
        ),
      );
}

/// {@macro example_starfield}
class ExampleStarfield extends StatefulWidget {
  /// {@template example_starfield}
  /// 🎊🚀🌌 Warp Speed!
  ///
  /// Zoom and pan this InteractiveViewer containing a generated "starfield",
  /// replete with randomness and parallax.
  ///
  /// Parallax for this demo is based on accelerometer only.
  /// Pointer is supported for the InteractiveViewer only.
  /// The FAB will `setState()` and generate a new starfield.
  /// {@endtemplate}
  const ExampleStarfield({Key? key}) : super(key: key);

  @override
  _ExampleStarfieldState createState() => _ExampleStarfieldState();
}

class _ExampleStarfieldState extends State<ExampleStarfield> {
  @override
  Widget build(BuildContext context) {
    const _duration = Duration(milliseconds: 250);
    const _ms = Duration(milliseconds: 1);
    final random = Random();
    final _starfield = <XL>[];

    final _colors = List.from(Colors.primaries)..shuffle();
    final _alignments = [
      Alignment.bottomCenter,
      Alignment.bottomLeft,
      Alignment.bottomRight,
      Alignment.center,
      Alignment.centerLeft,
      Alignment.centerRight,
      Alignment.topCenter,
      Alignment.topLeft,
      Alignment.topRight,
      Alignment(random.nextBool() ? 1 : -1 * random.nextDouble() * 6.0,
          random.nextBool() ? 1 : -1 * random.nextDouble() * 6.0),
      Alignment(random.nextBool() ? 1 : -1 * random.nextDouble() * 6.0,
          random.nextBool() ? 1 : -1 * random.nextDouble() * 6.0),
      Alignment(random.nextBool() ? 1 : -1 * random.nextDouble() * 6.0,
          random.nextBool() ? 1 : -1 * random.nextDouble() * 6.0),
    ]..shuffle();
    final _gradients = [
      Foils.gymClassParachute,
      Foils.linearLooping,
      Foils.linearLoopingReversed,
      Foils.linearRainbow,
      Foils.linearReversed,
      Foils.oilslick,
      Foils.rainbow,
      Foils.sitAndSpin,
      Foils.stepBowLinear,
      Foils.stepBowRadial,
      Foils.stepBowSweep
    ]..shuffle();

    for (var xl = 0; xl < 20; xl++) {
      final duration = _duration + _ms * random.nextInt(2500);
      final d = random.nextDouble();

      _starfield.add(
        XL(
          // This example is in an InteractiveViewer with its own
          // gesture detection, so this is an accelerometer-only demo.
          sharesPointer: false,
          sharesSensors: true,
          duration: duration,
          dragging: Dragging(duration: duration * 2), // FIXME ✝
          normalization:
              const Normalization(delay: Duration(milliseconds: 2500)),
          layers: [
            for (var layer = 0; layer < 25; layer++)
              XLayer(
                dimensionalOffset: 0.05,
                xRotation: 0.5,
                yRotation: 0.5,
                zRotationByX: 20,
                xOffset: 0,
                yOffset: 0,
                child: AnimatedAlign(
                  alignment: (_alignments..shuffle())[0] +
                      Alignment(random.nextDouble(), random.nextDouble()) -
                      Alignment(random.nextDouble(), random.nextDouble()),
                  duration: duration,
                  child: Foil.sheet(
                    opacity: 0.5,
                    duration: duration,
                    speed: const Duration(milliseconds: 250),
                    gradient: (_gradients..shuffle())[0],
                    sheet: Sheet(
                      width: (xl + 1) * d + layer / 25 - layer / 25 * d,
                      height: (xl + 1) * d + layer / 25 - layer / 25 * d,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (_colors..shuffle())[0],
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      );
    }

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      floatingActionButton:
          FloatingActionButton(onPressed: () => setState(() {})),
      body: InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(double.infinity),
        minScale: 0.01,
        maxScale: 12.5,
        child: Roll(
          crinkle: Crinkle.twinkling,
          child: Stack(children: [for (final xl in _starfield) xl]),
        ),
      ),
    );
  }
}

/// * # ✝
///
/// # FIXME
///
/// Despite not using pointer data to influence the parallax effect of
/// `XLayer`s by [XL.sharesPointer] set `false`,
/// a hovering pointer (or touched finger) will still influence the
/// parallax animation duration.
///
/// Work around this here by setting the [Dragging.duration]
/// to double that of the [XL.duration].
///
///
/// See `src/xl.dart` for current issue with normalization duration:
///
/// ```
/// SensorListener(
///   ...
///   normalizationDuration: widget.duration * 10, // FIXME
///   ...
/// ```
///
/// ## AND
///
/// ```
/// AnimatedXL(
///   ...
///   duration: hovering
///     ? widget.dragging.duration
///     : normalizing
///         ? widget.duration * 2 // FIXME
///         : widget.duration,
///   ...
/// ```
const markdownHover = null;
