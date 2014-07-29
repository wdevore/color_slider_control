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
  
  ColorValue calcDisplayColor() {
    ColorValue cv = new ColorValue();
    
    if (color != null && whiteness != null) {
      
      int r = color.r;
      int g = color.g;
      int b = color.b;

      // Apply brightness first as darkness is a multiplication operation.
      // Clamp to white if needed.
      r = min(255, r + whiteness.r);
      g = min(255, g + whiteness.g);
      b = min(255, b + whiteness.b);
      
      // Flip darklocation because we want the "left" end to be brighter.
      double dark = darkness.r / 255.0;
      r = (r * (1.0 - dark)).toInt();
      g = (g * (1.0 - dark)).toInt();
      b = (b * (1.0 - dark)).toInt();
      
      cv.set(r, g, b);
    }
    
    return cv;
  }

  @override
  String toString() {
    return "<$gradientlocation, endStop: $isEndStop>";
  }
}
