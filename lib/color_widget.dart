part of color_slider_control;

typedef void ColorChangedEvent(ColorData stop);

/**
 * There widget comprises of 3 controls:
 * 1) color box for showing the current color.
 * 2) a color slider for selecting a color.
 * 3) brightness control.
 * 
 *           Saturation               Value
 * box  ---- brightness -----  ------ darkness -------
 *      ------------------ color ------------------
 *                          Hue (in degrees)
 * 
 * Value: 
 *  color  -->  black
 *  255         0
 * Saturation:
 *  color  -->  white
 *  255         0
 * 
 * Full color: Value = Saturation = 255
 */
class ColorSliderWidget {
  DivElement container;
  DivElement innerContainer;

  SpanElement colorBox;
  ColorSlider _colorSlider;
  BrightnessSlider _brightnessSlider;
  DarknessSlider _darknessSlider;
  
  // Three main control colors.
  ColorValue color;
  double colorLocation = 0.5;
  
  ColorValue bright;
  double brightLocation = 0.5;
  
  ColorValue dark;
  double darkLocation = 0.5;
  
  // Color box
  ColorValue colorBoxValue = new ColorValue();
  ColorValue colorValue = new ColorValue();
  
  ColorData externalStop;
  
  bool _down = false;
  BaseSlider target;
  
  ColorChangedEvent _colorChangeCallback;
  bool _transmit = true;
  
  ColorSliderWidget() {
    container = new DivElement();
    container.classes.add("slider_color_container");

    innerContainer = new DivElement();
    innerContainer.classes.add("slider_gradient_container");
    container.nodes.add(innerContainer);
    
    colorBox = new SpanElement();
    colorBox.classes.add("slider_color_box");
    innerContainer.nodes.add(colorBox);

    // Bind the color control with a callback
    _brightnessSlider = new BrightnessSlider();
    _brightnessSlider.init("slider_color_brightness");
    _brightnessSlider.buildGradient();
    innerContainer.nodes.add(_brightnessSlider.container);
    
    _darknessSlider = new DarknessSlider();
    _darknessSlider.init("slider_color_darkness");
    _darknessSlider.buildGradient();
    innerContainer.nodes.add(_darknessSlider.container);

    _colorSlider = new ColorSlider();
    _colorSlider.init();
    _colorSlider.buildGradient();
    innerContainer.nodes.add(_colorSlider.container);
    
    container.onMouseDown.listen((MouseEvent e) {
      _mouseDown(e);
    });
    container.onMouseMove.listen((MouseEvent e) {
      _mouseMove(e);
    });
    container.onMouseUp.listen((MouseEvent e) {
      _mouseUp(e);
    });

  }

  void bind() {
    ColorData cd = new ColorData();
    _colorSlider.setDefaultAttributes(cd);
    _colorSlider.bind(_colorChanged);
    
    cd = new ColorData();
    _brightnessSlider.setDefaultAttributes(cd, "slider_marker_on_top", true);
    _brightnessSlider.bind(_brightnessChanged);
    
    cd = new ColorData();
    _darknessSlider.setDefaultAttributes(cd, "slider_marker_on_top", true);
    _darknessSlider.bind(_darknessChanged);
    
    _colorSlider.location = 0.5;
    _brightnessSlider.location = 0.0;
    _darknessSlider.location = 0.0;

    _darknessSlider.backgroundStyle = "linear-gradient(to right, ${colorBoxValue.toString()}, #000000)";
  }
  
  int getXOffset(MouseEvent e) {
    //print("getX: offset:${e.offset}, client:${e.client}");
    return e.client.x;// + _colorSlider.iconCenter * 2;
  }

  void _mouseDown(MouseEvent e) {
    _down = true;
    if (e.target == _colorSlider.markerIcon)
      target = _colorSlider;
    else if (e.target == _brightnessSlider.markerIcon)
      target = _brightnessSlider;
    else if (e.target == _darknessSlider.markerIcon)
      target = _darknessSlider;

    if (target != null) {
      target.mouseDown(getXOffset(e));
      e.preventDefault();
    }
  }

  void _mouseMove(MouseEvent e) {
    if (_down && target != null) {
      target.mouseMove(getXOffset(e));
      e.preventDefault();
    }
  }

  void _mouseUp(MouseEvent e) {
    _down = false;
  }

  set colorChangeCallback(ColorChangedEvent callback) => _colorChangeCallback = callback;
      
  // Called by either an external control (aka gradient_colorstops_control)
  void externalColorChange(ColorData stop) {
    _transmit = false;
    externalStop = stop;
    
    // An external control is telling us to switch to a new color configuration.
    color = stop.color;
    colorLocation = stop.colorLocation;
    _colorSlider.location = colorLocation;
    
    GradientValue gradient = _colorSlider.gradient;
    
    bright = stop.whiteness;
    // Set location for whiteness;
    double loc = bright.r / 255.0;
    _brightnessSlider.location = loc;
    
    dark = stop.darkness;
    loc = 1.0 - dark.r / 255.0;
    _darknessSlider.location = loc;

    _brightnessSlider.backgroundStyle = "linear-gradient(to right, ${color.toString()}, #ffffff)";
    _calcBright(colorValue);
    _darknessSlider.backgroundStyle = "linear-gradient(to right, ${colorValue.toString()}, #000000)";

    _transmit = true;
  }

  // Called by this control when markers are moved or updated. This
  // means the color, brightness and darkness sliders.
  void _colorChanged(ColorData stop) {
    color = stop.color;
    colorLocation = stop.colorLocation;
    
    _brightnessSlider.backgroundStyle = "linear-gradient(to right, ${color.toString()}, #ffffff)";
    
    _calcBright(colorValue);
    _darknessSlider.backgroundStyle = "linear-gradient(to right, ${colorValue.toString()}, #000000)";

    _update();
  }

  void _brightnessChanged(ColorData stop) {
    bright = stop.whiteness;
    brightLocation = stop.colorLocation;
    
    _calcBright(colorValue);
    _darknessSlider.backgroundStyle = "linear-gradient(to right, ${colorValue.toString()}, #000000)";

    _update();
  }
  
  void _darknessChanged(ColorData stop) {
    dark = stop.darkness;
    darkLocation = stop.colorLocation;
    _update();
  }
  
  ColorData get currentColorData {
    ColorData stop = new ColorData();
    stop.colorLocation = colorLocation;
    stop.displayColor = colorBoxValue;
    stop.color = color;
    stop.whiteness = bright;
    stop.darkness = dark;
    return stop;    
  }
  
  void _update() {
    _calcColor(colorBoxValue);
    colorBox.style.backgroundColor = colorBoxValue.toString();
    colorBox.title = colorBoxValue.toRgbString();
    
    if (_colorChangeCallback != null && _transmit) {
      ColorData stop = new ColorData();
      stop.colorLocation = colorLocation;
      stop.displayColor = colorBoxValue;
      stop.color = color;
      stop.whiteness = bright;
      stop.darkness = dark;
      stop.gradientlocation = externalStop.gradientlocation;
      _colorChangeCallback(stop);
    }
  }
  
  void _calcColor(ColorValue colorValue) {
    if (color != null && bright != null) {
      
      int r = color.r;
      int g = color.g;
      int b = color.b;

      // Apply brightness first as darkness is a multiplication operation.
      // Clamp to white if needed.
      r = min(255, r + bright.r);
      g = min(255, g + bright.g);
      b = min(255, b + bright.b);
      
      // Flip darklocation because we want the "left" end to be brighter.
      r = (r * (1.0 - darkLocation)).toInt();
      g = (g * (1.0 - darkLocation)).toInt();
      b = (b * (1.0 - darkLocation)).toInt();
      
      colorValue.set(r, g, b);
      
      colorBox.style.backgroundColor = colorValue.toString();
    }
  }
  
  void _calcBright(ColorValue colorValue) {
    if (color != null && bright != null) {
      
      int r = color.r;
      int g = color.g;
      int b = color.b;

      // Apply brightness first as darkness is a multiplication operation.
      // Clamp to white if needed.
      r = min(255, r + bright.r);
      g = min(255, g + bright.g);
      b = min(255, b + bright.b);
      
      colorValue.set(r, g, b);
      
      colorBox.style.backgroundColor = colorValue.toString();
    }
  }
}