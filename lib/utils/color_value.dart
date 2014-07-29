part of color_slider_control;

class ColorValue {
  /** Red color component. Value ranges from [0..255] */
  int r = 0;

  /** Green color component. Value ranges from [0..255] */
  int g = 0;

  /** Blue color component. Value ranges from [0..255] */
  int b = 0;

  /**
   * Parses the color value with the following format:
   *    "#fff"
   *    "#ffffff"
   *    "255, 255, 255"
   */
  ColorValue.from(String value) {
    if (value.startsWith("#")) {
      // Remove the #
      value = value.substring(1);
      _parseHex(value);
    }
    else if (value.contains(",")) {
      List<String> tokens = value.split(",");
      if (tokens.length < 3) {
        throw new Exception("Invalid color value format");
      }
      r = int.parse(tokens[0]);
      g = int.parse(tokens[1]);
      b = int.parse(tokens[2]);
      r = max(0, min(255, r));
      g = max(0, min(255, g));
      b = max(0, min(255, b));
    }
  }

  ColorValue() : r = 0, g = 0, b = 0;
  ColorValue.fromRGB(this.r, this.g, this.b);
  ColorValue.copy(ColorValue other) {
    this.r = other.r;
    this.g = other.g;
    this.b = other.b;
  }

  set fromColorValue(ColorValue other) {
    this.r = other.r;
    this.g = other.g;
    this.b = other.b;
  }
  
  void set(int r, int g, int b) {
    this.r = r;
    this.g = g;
    this.b = b;
  }

  /**
   * Parses the color value in the format FFFFFF or FFF
   * and is not case-sensitive
   */
  void _parseHex(String hex) {
    if (hex.length != 3 && hex.length != 6) {
      throw new Exception("Invalid color hex format");
    }

    if (hex.length == 3) {
      var a = hex.substring(0, 1);
      var b = hex.substring(1, 2);
      var c = hex.substring(2, 3);
      hex = "$a$a$b$b$c$c";
    }
    var hexR = hex.substring(0, 2);
    var hexG = hex.substring(2, 4);
    var hexB = hex.substring(4, 6);
    r = int.parse("0x$hexR");
    g = int.parse("0x$hexG");
    b = int.parse("0x$hexB");
  }

  ColorValue operator* (num value) {
    return new ColorValue.fromRGB(
        (r * value).toInt(),
        (g * value).toInt(),
        (b * value).toInt());
  }
  ColorValue operator+ (ColorValue other) {
    return new ColorValue.fromRGB(
        r + other.r,
        g + other.g,
        b + other.b);
  }

  ColorValue operator- (ColorValue other) {
    return new ColorValue.fromRGB(
        r - other.r,
        g - other.g,
        b - other.b);
  }

  bool operator> (ColorValue other) {
    return (r > other.r && g > other.g && b > other.b);
  }
  
  bool operator< (ColorValue other) {
    return (r < other.r && g < other.g && b < other.b);
  }
  
  bool equal(ColorValue other) {
    return (r == other.r && g == other.g && b == other.b);
  }
  
  String toString() => "rgba($r, $g, $b, 1.0)";
  String toRgbString() => "$r, $g, $b";
}


class HsvColor {

}