/// # 🕹️ xl
/// [pub.dev Listing](https://pub.dev/packages/xl) |
/// [API Doc](https://pub.dev/documentation/xl/latest) |
/// [GitHub](https://github.com/Zabadam/xl)
///
/// **API References: [`XL`](https://pub.dev/documentation/xl/latest/xl/XL-class.html)**
///
/// A package that provides the `XL` widget to implement accelerometer and/or
/// pointer and touch fueled parallax animations that smoothly transform
/// their children according to a spatial, three-dimensional
/// parallax layer definition.
///
/// - The **`XL`** Stack can generate fluidly moving *`Layer`s*
/// comprised of other widgets whose positions and rotations correlate to
/// either a pointer data or sensors data.
///   - This distinction is made by `XLayer` vs `PLayer`
///   - Whether the input methods cross-mingle is controlled by flag
/// ```
/// XL.sharesPointer // default is true; shares pointer with XLayers
/// XL.sharesSensors // default is false; does not share sensors with PLayers
/// ```
///
/// Also consider an `AutoXL` which makes a parallax stack
/// even easier to implement. \
/// Simply provide any old `Widget`s as `layers` \
/// and optionally tinker with the `depthFactor` or max layer `depth`.
/// - Pre-configured: `AutoXL.pane`, `AutoXL.wiggler`, `AutoXL.deep`
library xl;

export 'src/models/compensation.dart';
export 'src/models/dragging.dart';
export 'src/models/layer.dart';
export 'src/models/normalization.dart';
export 'src/models/reference_position.dart';
export 'src/widgets/auto_xl.dart';
export 'src/widgets/parallax_stack.dart';
export 'src/widgets/xl.dart';
