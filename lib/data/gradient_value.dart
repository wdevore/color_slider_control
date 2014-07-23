part of color_slider_control;

/** 
 * Represets a gradient color value. A gradient value contains a sequence of 
 * color transitional stops  
 */
class GradientValue {
  List<GradientStop> stops = new List<GradientStop>();
  /** Create a default gradient with 2 color stops on each end */
  GradientValue() {
    GradientStop start = new GradientStop(new ColorValue.fromRGB(0, 0, 0), 0);
    GradientStop end = new GradientStop(new ColorValue.fromRGB(255, 255, 255), 1);
    
    addStop(start);
    addStop(end);
  }
  
  GradientValue.from(this.stops) {
    sortStops();
  }
  
  void addStop(GradientStop stop) {
    stops.add(stop);
    sortStops();
  }
  void removeStop(GradientStop stop) {
    print (stop);
    stops.removeAt(stops.indexOf(stop));
  }

  void addStopValue(ColorValue color, num location) {
    addStop(new GradientStop(color, location));
  }
  void clear() => stops.clear();
  
  void sortStops() {
    stops.sort((a, b) { 
      if (a.location == b.location) return 0;
      return (a.location < b.location) ? -1 : 1;
    });
  }
  
  /** Gets the color value in the gradient */
  ColorValue getColor(num location, [bool sort = false]) {
    if (sort) {
      sortStops();
    }

    // Clamp the location value to 0..1
    location = max(0.0, min(1.0, location));
    
    if (location <= stops[0].location) {
      return new ColorValue.copy(stops[0].color);
    }
    
    // TODO: Optimize with a binary search
    for (var i = 0; i < stops.length - 1; i++) {
      final GradientStop nextStop = stops[i + 1]; 
      if (nextStop.location > location) {
        final GradientStop currentStop = stops[i];
        final num locationDelta = location - currentStop.location;
        final num percent = locationDelta / (nextStop.location - currentStop.location);
        final ColorValue targetColor = currentStop.color + (nextStop.color - currentStop.color) * percent;
        return targetColor;
      }
    }
    
    return new ColorValue.copy(stops.last.color);
  }
  
}

/** 
 * Represents a color value of the transition point in the gradient
 */
class GradientStop {
  GradientStop(this.color, this._location) {
    // Clamp the location value to 0..1
    location = max(0.0, min(1.0, location));
  }
  
  /** The value of the color represented by this grandient stop */
  ColorValue color;
  
  /** The transition point in the gradient.  Range is from [0..1] */
  num _location;
  num get location => _location;
  set location(num value) => _location = max(0, min(1, value));
  
  @override
  String toString() {
    return "stop: $location, color: $color";
  }
}

