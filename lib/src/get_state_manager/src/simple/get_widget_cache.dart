import 'package:flutter/widgets.dart';

/// An abstract widget that provides a caching mechanism for its child widgets.
///
/// Subclasses must implement the [createWidgetCache] method to provide
/// an instance of [WidgetCache].
abstract class GetWidgetCache extends Widget {
  const GetWidgetCache({super.key});

  @override
  GetWidgetCacheElement createElement() => GetWidgetCacheElement(this);

  /// Creates an instance of [WidgetCache] that will manage the state of this widget.
  @protected
  @factory
  WidgetCache createWidgetCache();
}

class GetWidgetCacheElement extends ComponentElement {
  GetWidgetCacheElement(GetWidgetCache widget)
      : widgetCache = widget.createWidgetCache(),
        super(widget) {
    widgetCache._element = this;
    widgetCache._widget = widget;
  }

  @override
  void mount(Element? parent, dynamic newSlot) {
    widgetCache.onInit();
    super.mount(parent, newSlot);
  }

  @override
  Widget build() {
    return widgetCache.build(this);
  }

  final WidgetCache<GetWidgetCache> widgetCache;

  @override
  void activate() {
    super.activate();
    markNeedsBuild();
  }

  @override
  void unmount() {
    super.unmount();
    widgetCache.onClose();
    widgetCache._element = null;
  }
}

@optionalTypeArgs
abstract class WidgetCache<T extends GetWidgetCache> {
  T? get widget => _widget;
  T? _widget;

  BuildContext? get context => _element;

  GetWidgetCacheElement? _element;

  @protected
  @mustCallSuper
  void onInit() {
    // Initialization logic goes here.
  }

  @protected
  @mustCallSuper
  void onClose() {
    // Cleanup logic goes here.
  }

  @protected
  Widget build(BuildContext context);
}
