part of color_slider_control;

/**
 * 
 */
abstract class BaseSlider {
  SpanElement container;

  /** An element to display color rainbow */
  SpanElement gradientElement;

  List<ColorData> markers = new List<ColorData>();
  ColorData selectedStop;
  
  GradientValue gradient;
  
  ColorChangedEvent _changeCallback;
  
  int _posX;
  int _prevX;
  int pX;
  bool _down = false;
  int iconWidth = 20;
  int iconCenter = 0;

  int xMin;
  int xMax;
  double _currentLocation;
  int _currentPosition;
  
  int index = 0;
  
  BaseSlider();

  void init() {
    container = new SpanElement();
  }
  
  void setDefaultAttributes(ColorData cd, [String markerClass = "slider_marker_on_bottom", bool toTop = false]) {
    // Add a marker icon for color sliding.
    if (markers.isEmpty)
      addMarker(cd, Base64Resources.markerPin);
    
    orientMarker(markerClass);

    if (toTop)
      setTop();
    else
      setToBottom();
    
    title = "Drag marker.";
  }

  ColorValue get color {
    return gradient.getColor(getLocation(_currentPosition));
  }
  
  set backgroundStyle(String style) {
    gradientElement.style.background = style;
  }
  
  void orientMarker(String className) {
    selectedStop.icon.classes.add(className);
  }

  void setMarkerLocation(int x) {
      double loc = getLocation(x - iconCenter);
      selectedStop.gradientlocation = loc;
  }
  
  void setTop() {
    selectedStop.icon.style.top = (-gradientElement.offsetHeight + iconWidth ~/ 2).toString() + "px";
  }
  
  void setToBottom() {
    selectedStop.icon.style.top = (gradientElement.offsetHeight + iconWidth).toString() + "px";
  }
  
  set title(String t) => selectedStop.icon.title = t;
  set barTitle(String t) => gradientElement.title = t;

  ImageElement get markerIcon => selectedStop.icon;
  
  ImageElement addMarker(ColorData cd, String base64Resource) {
    ImageElement icon = _loadIcon("data:image/svg+xml;base64," + base64Resource, iconWidth, iconWidth);
    cd.icon = icon;
    markers.add(cd);
    selectedStop = cd;
    return icon;
  }
  
  ImageElement addMarkerToBottom(ColorData cd, String base64Resource, [String markerClass = "slider_marker_on_bottom"]) {

    ImageElement icon = addMarker(cd, base64Resource);
    container.nodes.add(icon);
    
    setToBottom();
    
    orientMarker(markerClass);

    return icon;
  }
  
  void removeMarker(HtmlElement target) {
    container.nodes.remove(target);
    ColorData cd = markers.firstWhere((ColorData cd) => cd.icon == target, orElse: () => null);

    if (cd != null)
      markers.remove(cd);
    
    selectedStop = null;
  }
  
  void _preBind(ColorChangedEvent changeCallback) {
    _changeCallback = changeCallback;
    
    iconCenter = iconWidth ~/ 2;
  }
  
  void _bind() {
    markers.forEach((ColorData cd) => container.nodes.add(cd.icon));
    xMin = gradientElement.offsetLeft;
    xMax = xMin + gradientElement.clientWidth;
  }
  
  void _postBind() {
    // Update CSS gradient to match Stops.
  }
  
  void mouseDown(int x) {
    _posX = _prevX = x;
    print("down: $x");
    _update(selectedStop.icon.offsetLeft + iconCenter, 0);
  }
  
  void mouseMove(int x) {
    int dx = x - _prevX;
    print("move: x:$x, dx:$dx");
    int lpX = selectedStop.icon.offsetLeft;
    int pX = lpX;
    pX += dx;
    
    // gradientElement.clientLeft = border width.
    // However, if it is used we clip by 1 px which isn't good.
    if (pX > (xMax - iconCenter) || 
        pX < (xMin - iconCenter))
      pX = lpX;
    
    selectedStop.icon.style.left = (pX).toString() + "px";
    
    _prevX = x;
    _update(pX + iconCenter, 0);
  }
  
  /** Builds the gradient object. The gradient is saved for later reuse */
  void buildGradient([List<ColorValue> colors = null]);
  
  double getLocation(int position) {
    _currentLocation = (position - xMin) / (xMax - xMin);
    return _currentLocation;
  }

  double get location => _currentLocation;
  set location(double loc) {
    if (markers.isNotEmpty) {
      _currentLocation = loc;
      _currentPosition = xMin - iconCenter + (_currentLocation * gradientElement.clientWidth).toInt();
      selectedStop.icon.style.left = _currentPosition.toString() + "px";
      _update(_currentPosition + iconCenter, 0);
    }
  }
  
  int get barWidth => gradientElement.clientWidth;
  
  void _update(int x, int y) {
    /*
     * -----|-------------------|
     *     xMin                xMax
     *      0                   1 
     */
    _currentPosition = x;
  }
  
  ImageElement _loadIcon(String source, int iWidth, int iHeight) {
    ImageElement i = new ImageElement(src: source, width: iWidth, height:
        iHeight);
    i.onLoad.listen(_onData, onError: _onError, onDone: _onDone, cancelOnError:
        true);
    return i;
  }

  void _onData(Event e) {
  }

  void _onError(Event e) {
    print("Resources error: $e");
  }

  void _onDone() {
    print("done");
  }

}
