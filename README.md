# Dart Color Slider Selector

This control creates a simple color selector where the RGB values can be selected by sliding markers. It is designed purely in CSS/SVG/Dart; there is no Canvas rendering occurring.

![Color Selector](https://raw.githubusercontent.com/wdevore/gradient_colorstops_control/master/gradient_selector.png)

##pubspec
Start by adding a dependency for the Color Selector [library](https://github.com/wdevore/color_slider_control) in pubspec.yaml
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

##Design
The active `marker` is highlighted as darkgreen. Unselected `marker`s are blurred, grayscaled and translucent. The end `marker`s are highlighted in darkred and not movable.

