part of color_slider_control;

/**
 * 
 */
class DarknessSlider extends BaseSlider {
  
  DarknessSlider();

  void init([String gradientClass = "slider_color_darkness"]) {
    super.init();
    
    gradientElement = new SpanElement();
    gradientElement.classes.add(gradientClass);
    
    container.nodes.add(gradientElement);
  }
  
  void bind(ColorChangedEvent changeCallback) {
    super._preBind(changeCallback);
    
    super._bind();

    super._postBind();
  }
  
  @override
  void _update(int x, int y) {
    super._update(x, y);
    
    if (_changeCallback != null) {
      num loc = getLocation(_currentPosition);
      ColorData stop = new ColorData();
      stop.darkness = color;
      stop.colorLocation = loc;
      _changeCallback(stop);
    }
  }

  /** Builds the gradient object. The gradient is saved for later reuse */
  void buildGradient([List<ColorValue> colors = null]) {
    if (colors == null) {
      colors = [
                 new ColorValue.fromRGB(255, 255, 255), 
                 new ColorValue.fromRGB(0, 0, 0)
                 ];
    }
    
    List<GradientStop> stops = new List<GradientStop>();
    
    // Calculate the gradient stop delta for each color
    final gradientStopDelta = 1 / (colors.length - 1);
    num gradientStop = 0;
    for (var i = 0; i < colors.length - 1; i++) {
      GradientStop stop = new GradientStop(colors[i], gradientStop);
      stops.add(stop);
      gradientStop += gradientStopDelta;
    }
    // Add the last one manually to avoid precision issues
    GradientStop stop = new GradientStop(colors[colors.length-1], 1.0);
    stops.add(stop);
    
    gradient = new GradientValue.from(stops);
  }

}
