# Dart Color Slider Selector

This control creates a simple color selector where the RGB values can be selected by sliding markers.

![Color Selector](https://raw.githubusercontent.com/wdevore/gradient_colorstops_control/master/gradient_selector.png)

Start by adding a dependency of the Color Selector [library](https://github.com/wdevore/color_slider_control) in pubspec.yaml
```yaml
    dependencies:
      color_slider_control:
        git: git://github.com/wdevore/color_slider_control.git
```
Import the library into your project

```dart
    import 'package:color_slider_control/color_slider_control.dart';
```

Create the color selector by instantiating the `ColorSliderWidget` object, then add it to a container element and finally call the `bind` on the color selector.
```dart
    void main() {
      ColorSliderWidget colorWidget = new ColorSliderWidget();
      _targetContainerElement = querySelector("#color_pickerId");

      _targetContainerElement.nodes.add(colorWidget.container);
      colorWidget.bind();
    }
```

The selector defaults to a light teal color.