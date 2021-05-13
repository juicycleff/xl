/// Incorporates the [ParallaxStack] widget into the `XL` stack.
/// - Extension of [XL] for posterity and developer preference
///
/// Extends [PLayer] to [ParallaxLayer] and [XLayer] to [AcceleraxLayer].
library xl;

import 'package:flutter/widgets.dart';

import '../models/dragging.dart';
import '../models/layer.dart';
import '../models/normalization.dart';
import '../models/reference_position.dart';
import 'xl.dart';

/// {@macro xl}
class ParallaxStack extends XL {
  /// {@macro xl}
  const ParallaxStack({
    Key? key,
    List<Widget>? layers,
    bool sharesPointer = true,
    bool sharesSensor = false,
    Dragging dragging = const Dragging(),
    Normalization normalization = const Normalization(),
    Duration duration = const Duration(milliseconds: 250),
    Curve curve = Curves.ease,
    bool useLocalPosition = true,
    ReferencePosition referencePosition = ReferencePosition.center,
    VoidCallback? onPointerEnter,
    VoidCallback? onPointerExit,
  }) : super(
          key: key,
          layers: layers ?? const [],
          sharesPointer: sharesPointer,
          sharesSensors: sharesSensor,
          dragging: dragging,
          normalization: normalization,
          duration: duration,
          curve: curve,
          useLocalPosition: useLocalPosition,
          referencePosition: referencePosition,
          onPointerEnter: onPointerEnter,
          onPointerExit: onPointerExit,
        );
}

/// {@macro player}
class ParallaxLayer extends PLayer {
  /// {@macro player}
  const ParallaxLayer({
    Key? key,
    double xOffset = 0.0,
    double yOffset = 0.0,
    double xRotation = 0.0,
    double yRotation = 0.0,
    double zRotation = 0.0,
    bool enable3d = true,
    double dimensionalOffset = 0.001,
    Offset offset = const Offset(0, 0),
    Widget? child,
  }) : super(
          key: key,
          xOffset: xOffset,
          yOffset: yOffset,
          xRotation: xRotation,
          yRotation: yRotation,
          zRotation: zRotation,
          enable3d: enable3d,
          dimensionalOffset: dimensionalOffset,
          offset: offset,
          child: child ?? const SizedBox(),
        );
}

/// {@macro xlayer}
class AcceleraxLayer extends XLayer {
  /// {@macro xlayer}
  const AcceleraxLayer({
    Key? key,
    double xOffset = 0.0,
    double yOffset = 0.0,
    double xRotation = 0.0,
    double yRotation = 0.0,
    double zRotationByX = 0.0,
    double zRotationByGyro = 0.0,
    bool enable3d = true,
    double dimensionalOffset = 0.001,
    Offset offset = const Offset(0, 0),
    Widget? child,
  }) : super(
          key: key,
          xOffset: xOffset,
          yOffset: yOffset,
          xRotation: xRotation,
          yRotation: yRotation,
          zRotationByX: zRotationByX,
          zRotationByGyro: zRotationByGyro,
          enable3d: enable3d,
          dimensionalOffset: dimensionalOffset,
          offset: offset,
          child: child ?? const SizedBox(),
        );
}
