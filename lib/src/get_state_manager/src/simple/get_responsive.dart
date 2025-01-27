import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:getx/src/get_state_manager/src/simple/get_controllers.dart';
import 'package:getx/src/get_utils/src/extensions/context_extensions.dart';
import 'package:getx/src/get_utils/src/platform/platform.dart';

/// Mixin that provides responsive behavior for widgets based on screen size.
/// This mixin allows you to define how your widget should behave on different
/// screen types (desktop, tablet, phone, watch).
mixin GetResponsiveMixin on StatelessWidget {
  ResponsiveScreen get screen; // Provides information about the current screen
  bool get alwaysUseBuilder; // Flag to determine if the builder method should always be used

  @override
  Widget build(BuildContext context) {
    screen.context = context; // Set the current context for the screen
    Widget? widget;

    // If alwaysUseBuilder is true, use the builder method
    if (alwaysUseBuilder) {
      widget = builder();
      if (widget != null) return widget; // Return if a widget is built
    }

    // Determine which widget to build based on screen type
    if (screen.isDesktop) {
      widget = desktop() ?? widget; // Build desktop widget if applicable
      if (widget != null) return widget;
    }
    if (screen.isTablet) {
      widget = tablet() ?? desktop(); // Build tablet widget or fallback to desktop
      if (widget != null) return widget;
    }
    if (screen.isPhone) {
      widget = phone() ?? tablet() ?? desktop(); // Build phone widget or fallback to tablet/desktop
      if (widget != null) return widget;
    }

    // Fallback to watch or builder if no specific widget is found
    return watch() ?? phone() ?? tablet() ?? desktop() ?? builder()!;
  }

  /// Optional method to build a generic widget.
  Widget? builder() => null;

  /// Optional method to build a desktop-specific widget.
  Widget? desktop() => null;

  /// Optional method to build a phone-specific widget.
  Widget? phone() => null;

  /// Optional method to build a tablet-specific widget.
  Widget? tablet() => null;

  /// Optional method to build a watch-specific widget.
  Widget? watch() => null;
}

/// A responsive view that adapts its layout based on the screen size.
/// This class provides the `screen` property with information about the current
/// screen size and type. You can build your UI using:
/// - The `builder` method for general purposes.
/// - Specific methods (`desktop`, `tablet`, `phone`, `watch`) that are called
///   based on the current screen type.
///
/// Note: If using specific methods, set `alwaysUseBuilder` to false.
class GetResponsiveView<T> extends StatelessWidget with GetResponsiveMixin, DiagnosticableTreeMixin {
  @override
  final bool alwaysUseBuilder;

  @override
  final ResponsiveScreen screen;

  GetResponsiveView({
    this.alwaysUseBuilder = false,
    ResponsiveScreenSettings settings = const ResponsiveScreenSettings(),
    super.key,
  }) : screen = ResponsiveScreen(settings);

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    return <DiagnosticsNode>[];
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('alwaysUseBuilder', alwaysUseBuilder));
    properties.add(DiagnosticsProperty<ResponsiveScreen>('screen', screen));
  }

  @override
  DiagnosticsNode toDiagnosticsNode({
    String? name,
    DiagnosticsTreeStyle? style,
  }) {
    return DiagnosticsNode.message(name ?? 'GetResponsiveView');
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GetResponsiveView<$T>';
  }

  @override
  String toStringShallow({
    String joiner = ', ',
    DiagnosticLevel minLevel = DiagnosticLevel.debug,
  }) {
    return toString(minLevel: minLevel);
  }
}

/// A responsive widget that adapts its layout based on the screen size.
/// This class is designed for use with GetX controllers and provides
/// responsive capabilities similar to `GetResponsiveView`.
class GetResponsiveWidget<T extends GetxController> extends StatelessWidget with GetResponsiveMixin, DiagnosticableTreeMixin {
  @override
  final bool alwaysUseBuilder;

  @override
  final ResponsiveScreen screen;

  GetResponsiveWidget({
    this.alwaysUseBuilder = false,
    ResponsiveScreenSettings settings = const ResponsiveScreenSettings(),
    super.key,
  }) : screen = ResponsiveScreen(settings);

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    return <DiagnosticsNode>[];
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('alwaysUseBuilder', alwaysUseBuilder));
    properties.add(DiagnosticsProperty<ResponsiveScreen>('screen', screen));
  }

  @override
  DiagnosticsNode toDiagnosticsNode({
    String? name,
    DiagnosticsTreeStyle? style,
  }) {
    return DiagnosticsNode.message(name ?? 'GetResponsiveWidget');
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GetResponsiveWidget<$T>';
  }

  @override
  String toStringShallow({
    String joiner = ', ',
    DiagnosticLevel minLevel = DiagnosticLevel.debug,
  }) {
    return toString(minLevel: minLevel);
  }
}

/// Settings for configuring responsive behavior based on screen width.
class ResponsiveScreenSettings {
  final double desktopChangePoint; // Width threshold for displaying as [ScreenType.Desktop].

  final double tabletChangePoint; // Width threshold for displaying as [ScreenType.Tablet].

  final double watchChangePoint; // Width threshold for displaying as [ScreenType.Watch].

  const ResponsiveScreenSettings({
    this.desktopChangePoint = 1200,
    this.tabletChangePoint = 600,
    this.watchChangePoint = 300,
  });
}

/// This class provides information about the current screen size and type.
class ResponsiveScreen {
  late BuildContext context; // Current build context

  final ResponsiveScreenSettings settings; // Settings for responsive behavior

  final bool _isPlatformDesktop; // Flag indicating if the platform is desktop

  ResponsiveScreen(this.settings) : _isPlatformDesktop = GetPlatform.isDesktop;

  double get height => context.height; // Current height of the context

  double get width => context.width; // Current width of the context

  bool get isDesktop => (screenType == ScreenType.desktop); // Checks if current type is Desktop

  bool get isTablet => (screenType == ScreenType.tablet); // Checks if current type is Tablet

  bool get isPhone => (screenType == ScreenType.phone); // Checks if current type is Phone

  bool get isWatch => (screenType == ScreenType.watch); // Checks if current type is Watch

  double get _getDeviceWidth {
    if (_isPlatformDesktop) {
      return width;
    }
    return context.mediaQueryShortestSide;
  }

  ScreenType get screenType {
    final deviceWidth = _getDeviceWidth;

    if (deviceWidth >= settings.desktopChangePoint) return ScreenType.desktop;

    if (deviceWidth >= settings.tabletChangePoint) return ScreenType.tablet;

    if (deviceWidth < settings.watchChangePoint) return ScreenType.watch;

    return ScreenType.phone;
  }

  T? responsiveValue<T>({
    T? mobile,
    T? tablet,
    T? desktop,
    T? watch,
  }) {
    if (isDesktop && desktop != null) return desktop;

    if (isTablet && tablet != null) return tablet;

    if (isPhone && mobile != null) return mobile;

    return watch; // Return watch value as fallback
  }
}

/// Enum representing different types of screens.
enum ScreenType {
  watch,

  phone,

  tablet,

  desktop,
}

/*
mixin GetResponsiveMixin on StatelessWidget {
  ResponsiveScreen get screen;
  bool get alwaysUseBuilder;

  @override
  StatelessElement createElement() => StatelessElement(this);

  @override
  Widget build(BuildContext context) {
    screen.context = context;
    Widget? widget;

    if (alwaysUseBuilder) {
      widget = builder();
      if (widget != null) return widget;
    }

    if (screen.isDesktop) {
      widget = desktop() ?? widget;
      if (widget != null) return widget;
    }

    if (screen.isTablet) {
      widget = tablet() ?? desktop();
      if (widget != null) return widget;
    }

    if (screen.isPhone) {
      widget = phone() ?? tablet() ?? desktop();
      if (widget != null) return widget;
    }

    return watch() ?? phone() ?? tablet() ?? desktop() ?? builder()!;
  }

  Widget? builder() => null;
  Widget? desktop() => null;
  Widget? phone() => null;
  Widget? tablet() => null;
  Widget? watch() => null;
}

class GetResponsiveView<Controller> extends StatelessWidget with GetResponsiveMixin, DiagnosticableTreeMixin {
  @override
  final bool alwaysUseBuilder;

  @override
  final ResponsiveScreen screen;

  GetResponsiveView({
    this.alwaysUseBuilder = false,
    ResponsiveScreenSettings settings = const ResponsiveScreenSettings(),
    super.key,
  }) : screen = ResponsiveScreen(settings);

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    return <DiagnosticsNode>[];
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('alwaysUseBuilder', alwaysUseBuilder));
    properties.add(DiagnosticsProperty<ResponsiveScreen>('screen', screen));
  }

  @override
  DiagnosticsNode toDiagnosticsNode({
    String? name,
    DiagnosticsTreeStyle? style,
  }) {
    return DiagnosticsNode.message(name ?? 'GetResponsiveView');
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GetResponsiveView<$Controller>';
  }

  @override
  String toStringDeep({
    String prefixLineOne = '',
    String? prefixOtherLines,
    DiagnosticLevel minLevel = DiagnosticLevel.debug,
    int wrapWidth = 65,
  }) {
    return toStringDeep(
      prefixLineOne: prefixLineOne,
      prefixOtherLines: prefixOtherLines,
      minLevel: minLevel,
      wrapWidth: wrapWidth,
    );
  }

  @override
  String toStringShallow({
    String joiner = ', ',
    DiagnosticLevel minLevel = DiagnosticLevel.debug,
  }) {
    return toString(minLevel: minLevel);
  }

  @override
  String toStringShort() => 'GetResponsiveView<$Controller>';

  @override
  Widget build(BuildContext context) => throw UnimplementedError();
  @override
  Key? get key => throw UnimplementedError();
}

class GetResponsiveWidget<T extends GetxController> extends StatelessWidget with GetResponsiveMixin, DiagnosticableTreeMixin {
  @override
  final bool alwaysUseBuilder;

  @override
  final ResponsiveScreen screen;

  GetResponsiveWidget({
    this.alwaysUseBuilder = false,
    ResponsiveScreenSettings settings = const ResponsiveScreenSettings(),
    super.key,
  }) : screen = ResponsiveScreen(settings);

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    return <DiagnosticsNode>[];
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('alwaysUseBuilder', alwaysUseBuilder));
    properties.add(DiagnosticsProperty<ResponsiveScreen>('screen', screen));
  }

  @override
  DiagnosticsNode toDiagnosticsNode({
    String? name,
    DiagnosticsTreeStyle? style,
  }) {
    return DiagnosticsNode.message(name ?? 'GetResponsiveWidget');
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GetResponsiveWidget<$T>';
  }

  @override
  String toStringDeep({
    String prefixLineOne = '',
    String? prefixOtherLines,
    DiagnosticLevel minLevel = DiagnosticLevel.debug,
    int wrapWidth = 65,
  }) {
    return toStringDeep(
      prefixLineOne: prefixLineOne,
      prefixOtherLines: prefixOtherLines,
      minLevel: minLevel,
      wrapWidth: wrapWidth,
    );
  }

  @override
  String toStringShallow({
    String joiner = ', ',
    DiagnosticLevel minLevel = DiagnosticLevel.debug,
  }) {
    return toString(minLevel: minLevel);
  }

  @override
  String toStringShort() => 'GetResponsiveWidget<$T>';

  @override
  Key? get key => throw UnimplementedError();
}

class ResponsiveScreenSettings {
  final double desktopChangePoint;
  final double tabletChangePoint;
  final double watchChangePoint;

  const ResponsiveScreenSettings({
    this.desktopChangePoint = 1200,
    this.tabletChangePoint = 600,
    this.watchChangePoint = 300,
  });
}

class ResponsiveScreen {
  late BuildContext context;
  final ResponsiveScreenSettings settings;
  final bool _isPlatformDesktop;

  ResponsiveScreen(this.settings) : _isPlatformDesktop = GetPlatform.isDesktop;

  double get height => context.height;
  double get width => context.width;

  bool get isDesktop => (screenType == ScreenType.desktop);
  bool get isTablet => (screenType == ScreenType.tablet);
  bool get isPhone => (screenType == ScreenType.phone);
  bool get isWatch => (screenType == ScreenType.watch);

  double get _getDeviceWidth {
    if (_isPlatformDesktop) {
      return width;
    }
    return context.mediaQueryShortestSide;
  }

  ScreenType get screenType {
    final deviceWidth = _getDeviceWidth;
    if (deviceWidth >= settings.desktopChangePoint) return ScreenType.desktop;
    if (deviceWidth >= settings.tabletChangePoint) return ScreenType.tablet;
    if (deviceWidth < settings.watchChangePoint) return ScreenType.watch;
    return ScreenType.phone;
  }

  T? responsiveValue<T>({
    T? mobile,
    T? tablet,
    T? desktop,
    T? watch,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    if (isPhone && mobile != null) return mobile;
    return watch;
  }
}

enum ScreenType {
  watch,
  phone,
  tablet,
  desktop,
}
*/
