import 'dart:html';

import 'package:color_slider_control/color_slider_control.dart';

DivElement _targetContainerElement;

void main() {
  ColorSliderWidget colorWidget = new ColorSliderWidget();
  _targetContainerElement = querySelector("#color_pickerId");

  _targetContainerElement.nodes.add(colorWidget.container);
  colorWidget.bind();
}


