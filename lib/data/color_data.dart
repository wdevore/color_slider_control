part of color_slider_control;

class ColorData {
  bool isEndStop = false;
  
  ImageElement icon;
  
  ColorValue displayColor;
  ColorValue color;
  ColorValue whiteness;
  ColorValue darkness;
  
  // Location relative to gradient control
  double gradientlocation = 0.0;
  
  // Location relative to the color control
  // This value is passed back and forth between controls.
  double colorLocation = 0.0;
  
  ColorData();

  ColorData.colorCopy(ColorData other) {
    colorLocation = other.colorLocation;
    displayColor = new ColorValue.copy(other.displayColor);
    color = new ColorValue.copy(other.color);
    whiteness = new ColorValue.copy(other.whiteness);
    darkness = new ColorValue.copy(other.darkness);
  }

  ColorData.copy(ColorData other) {
    if (other.icon != null)
      icon = icon.clone(false);
    gradientlocation = other.gradientlocation;
    colorLocation = other.colorLocation;
    displayColor = new ColorValue.copy(other.displayColor);
    color = new ColorValue.copy(other.color);
    whiteness = new ColorValue.copy(other.whiteness);
    darkness = new ColorValue.copy(other.darkness);
  }
  
  @override
  String toString() {
    return "<$gradientlocation, endStop: $isEndStop>";
  }
}
