part of color_slider_control;

/**
 */
class ColorSlider extends BaseSlider {

  ColorSlider();
  
  void init([String gradientClass = "slider_color_rainbow"]) {
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
      stop.colorLocation = loc;
      stop.color = color;
      _changeCallback(stop);
    }
  }
  
  /** Builds the color gradient object. The gradient is saved for later reuse */
  void buildGradient([List<ColorValue> colors = null]) {
    if (colors == null) {
      // Default to a rainbow.
      colors = [
         new ColorValue.fromRGB(255, 0, 0), 
         new ColorValue.fromRGB(255, 255, 0), 
         new ColorValue.fromRGB(0, 255, 0), 
         new ColorValue.fromRGB(0, 255, 255), 
         new ColorValue.fromRGB(0, 0, 255), 
         new ColorValue.fromRGB(255, 0, 255),
         new ColorValue.fromRGB(255, 0, 0)
         ];
    }
    
    // Update CSS gradient to match color stops.
    updateCSSGradient(colors);
    
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
  
  ColorData selectedMarker(HtmlElement target) {
    selectedStop = markers.firstWhere((ColorData cd) => cd.icon == target, orElse: () => null);
    if (selectedStop != null) {
      title = "loc: ${selectedStop.colorLocation}";
    }
    return selectedStop;
  }
  
  ColorData replaceWith(ColorData original, ColorData stop) {
    int indexOf = markers.indexOf(original);
    markers[indexOf] = stop;
    return markers[indexOf];
  }
  
  void unselectAll() {
    // Reset all selections
    for(ColorData cs in markers) {
      if (cs.isEndStop)
        highlightAsEndMarker(cs);
      else
        highlightAsUnSelected(cs);
    }
  }
  
  void highlightAsEndMarker(ColorData stop) {
    stop.icon.style.filter = "hue-rotate(0deg) brightness(0.5) opacity(0.5)";
  }
  
  void highlightAsSelected(ColorData stop) {
    stop.icon.style.filter = "hue-rotate(90deg) brightness(1.5) drop-shadow(-2px -2px 2px gray)";
  }
  
  void highlightAsUnSelected(ColorData stop) {
    // Gray
    stop.icon.style.filter = "grayscale(1.0) brightness(3.0) blur(1px) opacity(0.5)";
  }

  void sortStops(List<ColorData> stops) {
    stops.sort((a, b) { 
      if (a.gradientlocation == b.gradientlocation) return 0;
      return (a.gradientlocation < b.gradientlocation) ? -1 : 1;
    });
  }

  void replaceSelectedWith(ColorData stop) {
    if (selectedStop != null) {
      ColorData copy = new ColorData.colorCopy(stop);
      copy.isEndStop = selectedStop.isEndStop;
      copy.icon = selectedStop.icon;
      copy.gradientlocation = selectedStop.gradientlocation;
      
      selectedStop = replaceWith(selectedStop, copy);
      
      // update CSS
      updateCSSGradientWithStops();
    }
  }
  
  void updateCSSGradientWithStops() {
    String grad = "linear-gradient(to right, ";
    
    String cStops = "";
    
    List<ColorData> sorted = new List<ColorData>.from(markers, growable: false);
    sortStops(sorted);
    
    Iterable<ColorData> subList = sorted.getRange(0, sorted.length - 1);
    for(ColorData cv in subList) {
      cStops += "${cv.displayColor} ${(cv.gradientlocation * 100.0).toInt()}%,";
    }
    
    // Right Stop
    ColorData endStop = sorted[sorted.length - 1]; 
    cStops += "${endStop.displayColor} ${(endStop.gradientlocation * 100.0).toInt()}%";
    
    grad += cStops + ")";

    gradientElement.style.background = grad;
  }
  
  void updateCSSGradient(List<ColorValue> colors) {
    String grad = "linear-gradient(to right, ";
    String cStops = "";
    Iterable<ColorValue> subList = colors.getRange(0, colors.length - 1);
    for(ColorValue cv in subList) {
      cStops += cv.toString() + ",";
    }
    cStops += colors[colors.length - 1].toString();
    grad += cStops + ")";
    gradientElement.style.background = grad;
  }
}