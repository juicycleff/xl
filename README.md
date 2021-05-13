# XL

| [![XL Package Logotype](https://raw.githubusercontent.com/Zabadam/xl/master/example/android/app/src/main/res/drawable/xl.png 'Get started by adding `xl:` to your pubspec and importing `package:xl/xl.dart`')](https://pub.dev/packages/xl) | [![XL Logotype "Spinning Top"](https://raw.githubusercontent.com/Zabadam/xl/master/doc/xl.gif 'See `ExampleXL()` demo')](https://github.com/Zabadam/xl/blob/main/example/lib/main.dart#L276) |
| :-: | :-: |
| [![Starfield](https://raw.githubusercontent.com/Zabadam/xl/master/doc/starfield.gif 'See `ExampleStarfield()` demo')](https://github.com/Zabadam/xl/blob/main/example/lib/main.dart#L184) | [![Warpspeed](https://raw.githubusercontent.com/Zabadam/xl/master/doc/warpspeed.gif 'See `ExampleStarfield()` demo')](https://github.com/Zabadam/xl/blob/main/example/lib/main.dart#L184) |


A package providing the `XL` stack widget to implement accelerometer- and  
pointer-fueled parallax animations that smoothly transform  
children according to a spatial, three-dimensional layer definition.  
Touch and Gyroscope support included.

Design simple or elaborate *`XL`*-erometer driven interactions and interfaces.

## Getting Started
To get started with sensor data, use an `XL` with `XLayer`s:
 ```dart
const Widget xl = XL(layers: [XLayer(. . .), ...]);
 ```

To distinguish between pointer data (mouse/touch) and sensors data,  
employ `PLayer`s and the relevant flags:
 ```dart
const Widget xl = XL(
  sharesPointer = false, // default is true
  sharesSensors = false, // default is false
  layers: [
    PLayer(. . .), // ignores sensors
    PLayer(. . .), // ignores sensors
    XLayer(. . .), // ignores pointer
    ...
  ],
);
 ```

## Layers
The `XL.layers` property takes a list of `XLayers`s or `PLayers`s.

These `layers` allow you to define the animatable properties  
of their `child` widgets.

 ```dart
class Example extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(
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
                width: 200,
                height: 200,
                color: Colors.red,
          ))),
        ],
      ),
    ));
  }
}
 ```

That example yields the following result:  
[![Delicious parallax by accelerometer 🤤](https://raw.githubusercontent.com/Zabadam/xl/master/doc/example_100.gif 'Delicious parallax by accelerometer 🤤')](https://github.com/Zabadam/xl/blob/main/example/lib/main.dart#L34)

## Advanced Usage
As stated, an `XL` may have both varieties of layer interspersed.  
The default function of the stack is to apply *pointer* data to both  
varieties of `Layer`, and to only apply *sensors data* to `XLayer`s;  
there are, however, flags available to toggle either functionality, as:

```dart
const layers = [
  XLayer(/* Blue X Layer; reactive */),
  PLayer(/* Red P Layer; more reactive */),
  XLayer(/* Black Layer; non-reactive control */),
];

final example = Column(children: [
  Expanded(
    child: Row(children: [
      const Expanded(
        child: XL(
          // X and P Layers behave the same way with these flags
          // (but still may differ slightly on parameters for Z axis rotation).
          sharesPointer: true,
          sharesSensors: true,
          layers: layers,
      )),
      const Expanded(
        child: XL(
          // All Layers react to pointers, but only XLayers
          // will recognize sensors. Default flags.
          sharesPointer: true, // default
          sharesSensors: false, // default
          layers: layers,
  ))])),
  Expanded(
    child: Row(children: [
      const Expanded(
        child: XL(
          // All Layers react to sensors,
          // but only PLayers will recognize pointer.
          sharesPointer: false,
          sharesSensors: true,
          layers: layers,
      )),
      const Expanded(
        child: XL(
          // Each Layer will deal only with its prescribed input data.
          sharesPointer: false,
          sharesSensors: false,
          layers: layers,
  ))])),
]);
```

That same stack of `layers` laid out with these two flags  
in the four possible configurations would behave like this:  
[![Flags to handle \`XLayers\` and \`PLayers\` separately](https://raw.githubusercontent.com/Zabadam/xl/master/doc/sharing_inputs_300.gif 'Flags to handle `X` and `P Layers` separately')](https://github.com/Zabadam/xl/blob/main/example/lib/main.dart#L76)
> 🟥 Red layers are `PLayer`s and react primarily to pointers data.  
> 🟦 Blue layers are `XLayer`s and react primarily to sensors data.  
> ⬛ Black layers are `XLayer`s with *no animation properties*.
> They make no reaction to any input.
>   
> 👈 The left two 🟥 `PLayer`s also consider sensors data  
> 👆 The top two 🟦 `XLayer`s also consider pointer data


&nbsp;

## Reference

### Roadmap
1. Provide richer access to sensors data and ability to manipulate `Layer`s in new ways
   - Such as an `AccelSpec` and `GyroSpec` that would enable *transformation
   of* any axis based on *input from* any axis, determined by parameter.
     - Currently, for example, `yRotation` is controlled by accelerometer X axis
     rotation. `zRotation` may also be controlled by accelerometer X axis rotation
     with parameter `zRotationByX`. However, `zRotationByGyro` may interpret
     Z axis gyroscope rotations. It is the only axis with two such inputs.
     - Imagine declaring an axis to rotate or offset, then also determining
     which axis/sensor contributes to it. What deep options that could provide!
     Such as offsetting a `Widget` vertically *and* rotating it over Y axis
     based on only one input from accelerometer.
2. Along with **#1** above, provide more Gyroscope functionality
than only one axis of influence. 
   - Gyro is a little tricker, as the sensor mostly reads flat near-`0`
values *unless the device is moving*.
   - This still provides cool options for developers to make neat interactions,
and so should be expanded upon.

### Bugs
1. Discrepancy with normalization delay and normalization duration.

### History
*For posterity and developer preference, there are three extension "wrappers" available.*
- *Instead of the short, all-caps `XL`, consider a `ParallaxStack`*
- *Instead of the double-cap `XLayer`, consider an `AcceleraxLayer`*
- *Instead of the double-cap `PLayer`, consider a `ParallaxLayer`*

```dart
final xl = ParallaxStack( // XL
  sharesSensors: true, // same parameters and functionality
  layers: [
    AcceleraxLayer(. . .), // XLayer
    ParallaxLayer(. . .), // PLayer
  ],
);
```
- Furthermore, the [original website demo](https://github.com/Zabadam/xl/blob/main/website/ 'the_wave website demo from package:mouse_parallax, converted to package:xl') works well with accelerometer data.

##### **Forked from [`mouse_parallax`](https://pub.dev/packages/mouse_parallax 'pub.dev package: mouse_parallax') considering the required `AnimatedParallaxStack` widget is not exported with the original package and that accelerometers have nothing to do with mice.**
- ##### [License here.](https://pub.dev/packages/mouse_parallax/license 'pub.dev package: mouse_parallax | license')
