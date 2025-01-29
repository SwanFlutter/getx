import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:getx/src/get_core/get_core.dart';
import 'package:getx/src/get_instance/src/extension_instance.dart';
import 'package:getx/src/get_navigation/src/extension_navigation.dart';
import 'package:getx/src/get_navigation/src/root/internacionalization.dart';
import 'package:getx/src/get_navigation/src/routes/index.dart';
import 'package:getx/src/get_navigation/src/snackbar/snackbar_controller.dart';
import 'package:getx/src/get_state_manager/src/simple/get_state.dart';
import 'package:getx/src/get_utils/src/extensions/context_extensions.dart';
import 'package:getx/src/get_utils/src/extensions/event_loop_extensions.dart';
import 'package:getx/src/get_utils/src/extensions/internacionalization.dart';
import 'package:getx/src/get_utils/src/platform/platform.dart';

import '../router_report.dart';

/// Configuration data class that holds all GetX app settings and parameters
class ConfigData {
  /// Callback for routing events
  final ValueChanged<Routing?>? routingCallback;

  /// Default transition animation for routes
  final Transition? defaultTransition;

  /// Lifecycle callbacks
  final VoidCallback? onInit;
  final VoidCallback? onReady;
  final VoidCallback? onDispose;

  /// Logging configuration
  final bool? enableLog;
  final LogWriterCallback? logWriterCallback;

  /// Dependency injection and state management
  final SmartManagement smartManagement;
  final List<Bind> binds;

  /// Navigation and routing configuration
  final Duration? transitionDuration;
  final bool? defaultGlobalState;
  final List<GetPage>? getPages;
  final GetPage? unknownRoute;
  final RouteInformationProvider? routeInformationProvider;
  final RouteInformationParser<Object>? routeInformationParser;
  final RouterDelegate<Object>? routerDelegate;
  final BackButtonDispatcher? backButtonDispatcher;
  final List<NavigatorObserver>? navigatorObservers;
  final GlobalKey<NavigatorState>? navigatorKey;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;

  /// Internationalization settings
  final Map<String, Map<String, String>>? translationsKeys;
  final Translations? translations;
  final Locale? locale;
  final Locale? fallbackLocale;

  /// Route settings
  final String? initialRoute;
  final CustomTransition? customTransition;
  final Widget? home;

  /// Theme configuration
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final ThemeMode? themeMode;

  /// Navigation behavior settings
  final bool defaultPopGesture;
  final bool defaultOpaqueRoute;
  final Duration defaultTransitionDuration;
  final Curve defaultTransitionCurve;
  final Curve defaultDialogTransitionCurve;
  final Duration defaultDialogTransitionDuration;

  /// Internal state
  final bool testMode;
  final Key? unikey;
  final Routing routing;
  final Map<String, String?> parameters;
  final SnackBarQueue snackBarQueue = SnackBarQueue();

  ConfigData({
    required this.routingCallback,
    required this.defaultTransition,
    required this.onInit,
    required this.onReady,
    required this.onDispose,
    required this.enableLog,
    required this.logWriterCallback,
    required this.smartManagement,
    required this.binds,
    required this.transitionDuration,
    required this.defaultGlobalState,
    required this.getPages,
    required this.unknownRoute,
    required this.routeInformationProvider,
    required this.routeInformationParser,
    required this.routerDelegate,
    required this.backButtonDispatcher,
    required this.navigatorObservers,
    required this.navigatorKey,
    required this.scaffoldMessengerKey,
    required this.translationsKeys,
    required this.translations,
    required this.locale,
    required this.fallbackLocale,
    required this.initialRoute,
    required this.customTransition,
    required this.home,
    this.theme,
    this.darkTheme,
    this.themeMode,
    this.unikey,
    this.testMode = false,
    this.defaultOpaqueRoute = true,
    this.defaultTransitionDuration = const Duration(milliseconds: 300),
    this.defaultTransitionCurve = Curves.easeOutQuad,
    this.defaultDialogTransitionCurve = Curves.easeOutQuad,
    this.defaultDialogTransitionDuration = const Duration(milliseconds: 300),
    this.parameters = const {},
    Routing? routing,
    bool? defaultPopGesture,
  })  : defaultPopGesture = defaultPopGesture ?? GetPlatform.isIOS,
        routing = routing ?? Routing();

  ConfigData copyWith({
    ValueChanged<Routing?>? routingCallback,
    Transition? defaultTransition,
    VoidCallback? onInit,
    VoidCallback? onReady,
    VoidCallback? onDispose,
    bool? enableLog,
    LogWriterCallback? logWriterCallback,
    SmartManagement? smartManagement,
    List<Bind>? binds,
    Duration? transitionDuration,
    bool? defaultGlobalState,
    List<GetPage>? getPages,
    GetPage? unknownRoute,
    RouteInformationProvider? routeInformationProvider,
    RouteInformationParser<Object>? routeInformationParser,
    RouterDelegate<Object>? routerDelegate,
    BackButtonDispatcher? backButtonDispatcher,
    List<NavigatorObserver>? navigatorObservers,
    GlobalKey<NavigatorState>? navigatorKey,
    GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey,
    Map<String, Map<String, String>>? translationsKeys,
    Translations? translations,
    Locale? locale,
    Locale? fallbackLocale,
    String? initialRoute,
    CustomTransition? customTransition,
    Widget? home,
    bool? testMode,
    Key? unikey,
    ThemeData? theme,
    ThemeData? darkTheme,
    ThemeMode? themeMode,
    bool? defaultPopGesture,
    bool? defaultOpaqueRoute,
    Duration? defaultTransitionDuration,
    Curve? defaultTransitionCurve,
    Curve? defaultDialogTransitionCurve,
    Duration? defaultDialogTransitionDuration,
    Routing? routing,
    Map<String, String?>? parameters,
  }) {
    return ConfigData(
      routingCallback: routingCallback ?? this.routingCallback,
      defaultTransition: defaultTransition ?? this.defaultTransition,
      onInit: onInit ?? this.onInit,
      onReady: onReady ?? this.onReady,
      onDispose: onDispose ?? this.onDispose,
      enableLog: enableLog ?? this.enableLog,
      logWriterCallback: logWriterCallback ?? this.logWriterCallback,
      smartManagement: smartManagement ?? this.smartManagement,
      binds: binds ?? this.binds,
      transitionDuration: transitionDuration ?? this.transitionDuration,
      defaultGlobalState: defaultGlobalState ?? this.defaultGlobalState,
      getPages: getPages ?? this.getPages,
      unknownRoute: unknownRoute ?? this.unknownRoute,
      routeInformationProvider: routeInformationProvider ?? this.routeInformationProvider,
      routeInformationParser: routeInformationParser ?? this.routeInformationParser,
      routerDelegate: routerDelegate ?? this.routerDelegate,
      backButtonDispatcher: backButtonDispatcher ?? this.backButtonDispatcher,
      navigatorObservers: navigatorObservers ?? this.navigatorObservers,
      navigatorKey: navigatorKey ?? this.navigatorKey,
      scaffoldMessengerKey: scaffoldMessengerKey ?? this.scaffoldMessengerKey,
      translationsKeys: translationsKeys ?? this.translationsKeys,
      translations: translations ?? this.translations,
      locale: locale ?? this.locale,
      fallbackLocale: fallbackLocale ?? this.fallbackLocale,
      initialRoute: initialRoute ?? this.initialRoute,
      customTransition: customTransition ?? this.customTransition,
      home: home ?? this.home,
      testMode: testMode ?? this.testMode,
      unikey: unikey ?? this.unikey,
      theme: theme ?? this.theme,
      darkTheme: darkTheme ?? this.darkTheme,
      themeMode: themeMode ?? this.themeMode,
      defaultPopGesture: defaultPopGesture ?? this.defaultPopGesture,
      defaultOpaqueRoute: defaultOpaqueRoute ?? this.defaultOpaqueRoute,
      defaultTransitionDuration: defaultTransitionDuration ?? this.defaultTransitionDuration,
      defaultTransitionCurve: defaultTransitionCurve ?? this.defaultTransitionCurve,
      defaultDialogTransitionCurve: defaultDialogTransitionCurve ?? this.defaultDialogTransitionCurve,
      defaultDialogTransitionDuration: defaultDialogTransitionDuration ?? this.defaultDialogTransitionDuration,
      routing: routing ?? this.routing,
      parameters: parameters ?? this.parameters,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConfigData &&
        other.routingCallback == routingCallback &&
        other.defaultTransition == defaultTransition &&
        other.onInit == onInit &&
        other.onReady == onReady &&
        other.onDispose == onDispose &&
        other.enableLog == enableLog &&
        other.logWriterCallback == logWriterCallback &&
        other.smartManagement == smartManagement &&
        listEquals(other.binds, binds) &&
        other.transitionDuration == transitionDuration &&
        other.defaultGlobalState == defaultGlobalState &&
        listEquals(other.getPages, getPages) &&
        other.unknownRoute == unknownRoute &&
        other.routeInformationProvider == routeInformationProvider &&
        other.routeInformationParser == routeInformationParser &&
        other.routerDelegate == routerDelegate &&
        other.backButtonDispatcher == backButtonDispatcher &&
        listEquals(other.navigatorObservers, navigatorObservers) &&
        other.navigatorKey == navigatorKey &&
        other.scaffoldMessengerKey == scaffoldMessengerKey &&
        mapEquals(other.translationsKeys, translationsKeys) &&
        other.translations == translations &&
        other.locale == locale &&
        other.fallbackLocale == fallbackLocale &&
        other.initialRoute == initialRoute &&
        other.customTransition == customTransition &&
        other.home == home &&
        other.testMode == testMode &&
        other.unikey == unikey &&
        other.theme == theme &&
        other.darkTheme == darkTheme &&
        other.themeMode == themeMode &&
        other.defaultPopGesture == defaultPopGesture &&
        other.defaultOpaqueRoute == defaultOpaqueRoute &&
        other.defaultTransitionDuration == defaultTransitionDuration &&
        other.defaultTransitionCurve == defaultTransitionCurve &&
        other.defaultDialogTransitionCurve == defaultDialogTransitionCurve &&
        other.defaultDialogTransitionDuration == defaultDialogTransitionDuration &&
        other.routing == routing &&
        mapEquals(other.parameters, parameters);
  }

  @override
  int get hashCode {
    return routingCallback.hashCode ^
        defaultTransition.hashCode ^
        onInit.hashCode ^
        onReady.hashCode ^
        onDispose.hashCode ^
        enableLog.hashCode ^
        logWriterCallback.hashCode ^
        smartManagement.hashCode ^
        binds.hashCode ^
        transitionDuration.hashCode ^
        defaultGlobalState.hashCode ^
        getPages.hashCode ^
        unknownRoute.hashCode ^
        routeInformationProvider.hashCode ^
        routeInformationParser.hashCode ^
        routerDelegate.hashCode ^
        backButtonDispatcher.hashCode ^
        navigatorObservers.hashCode ^
        navigatorKey.hashCode ^
        scaffoldMessengerKey.hashCode ^
        translationsKeys.hashCode ^
        translations.hashCode ^
        locale.hashCode ^
        fallbackLocale.hashCode ^
        initialRoute.hashCode ^
        customTransition.hashCode ^
        home.hashCode ^
        testMode.hashCode ^
        unikey.hashCode ^
        theme.hashCode ^
        darkTheme.hashCode ^
        themeMode.hashCode ^
        defaultPopGesture.hashCode ^
        defaultOpaqueRoute.hashCode ^
        defaultTransitionDuration.hashCode ^
        defaultTransitionCurve.hashCode ^
        defaultDialogTransitionCurve.hashCode ^
        defaultDialogTransitionDuration.hashCode ^
        routing.hashCode ^
        parameters.hashCode;
  }
}

/// Root widget for GetX applications
/// Manages the application state, configuration, and lifecycle
class GetRoot extends StatefulWidget {
  const GetRoot({
    super.key,
    required this.config,
    required this.child,
  });

  final ConfigData config;
  final Widget child;

  @override
  State<GetRoot> createState() => GetRootState();

  /// Check if the GetX widget tree is initialized
  static bool get treeInitialized => GetRootState._controller != null;

  /// Get the root state from a BuildContext
  static GetRootState of(BuildContext context) {
    GetRootState? root;
    if (context is StatefulElement && context.state is GetRootState) {
      root = context.state as GetRootState;
    }
    root = context.findRootAncestorStateOfType<GetRootState>() ?? root;
    assert(() {
      if (root == null) {
        throw FlutterError(
          'GetRoot operation requested with a context that does not include a GetRoot.\n'
          'The context used must be that of a widget that is a descendant of a GetRoot widget.',
        );
      }
      return true;
    }());
    return root!;
  }
}

/// State management for GetRoot widget
/// Handles lifecycle, configuration, and state updates
class GetRootState extends State<GetRoot> with WidgetsBindingObserver {
  static GetRootState? _controller;

  /// Global access to root state controller
  static GetRootState get controller {
    if (_controller == null) {
      throw Exception('GetRoot is not part of the tree');
    }
    return _controller!;
  }

  late ConfigData config;

  @override
  void initState() {
    super.initState();
    config = widget.config;
    GetRootState._controller = this;
    ambiguate(Engine.instance)!.addObserver(this);
    onInit();
  }

  /// Initialize the application
  void onInit() {
    _validateConfiguration();
    _setupRouting();
    _setupInternationalization();
    _setupConfiguration();
    Future(() => onReady());
  }

  /// Validate required configuration
  void _validateConfiguration() {
    if (config.getPages == null && config.home == null) {
      throw 'You need to add pages or home';
    }
  }

  /// Setup routing configuration
  void _setupRouting() {
    if (config.routerDelegate == null) {
      _setupDefaultDelegate();
    }

    if (config.routeInformationParser == null) {
      _setupDefaultParser();
    }
  }

  /// Setup internationalization
  void _setupInternationalization() {
    if (config.locale != null) Get.locale = config.locale;
    if (config.fallbackLocale != null) Get.fallbackLocale = config.fallbackLocale;
    if (config.translations != null) {
      Get.addTranslations(config.translations!.keys);
    } else if (config.translationsKeys != null) {
      Get.addTranslations(config.translationsKeys!);
    }
  }

  /// Setup general configuration
  void _setupConfiguration() {
    Get.smartManagement = config.smartManagement;
    Get.isLogEnable = config.enableLog ?? kDebugMode;
    Get.log = config.logWriterCallback ?? defaultLogWriterCallback;

    if (config.defaultTransition == null) {
      config = config.copyWith(defaultTransition: getThemeTransition());
    }
  }

  /// Setup a default router delegate if none is provided
  void _setupDefaultDelegate() {
    config = config.copyWith(
      routerDelegate: GetDelegate(
        pages: config.getPages ?? [],
        navigatorKey: config.navigatorKey,
      ),
    );
  }

  /// Setup a default route information parser if none is provided
  void _setupDefaultParser() {
    config = config.copyWith(
      routeInformationParser: GetInformationParser(
        initialRoute: config.initialRoute ?? '/',
      ),
    );
  }

  void onClose() {
    config.onDispose?.call();
    Get.clearTranslations();
    config.snackBarQueue.disposeControllers();
    RouterReportManager.instance.clearRouteKeys();
    RouterReportManager.dispose();
    Get.resetInstance(clearRouteBindings: true);
    _controller = null;
    ambiguate(Engine.instance)!.removeObserver(this);
  }

  @override
  void dispose() {
    onClose();
    super.dispose();
  }

  void onReady() {
    config.onReady?.call();
  }

  Transition? getThemeTransition() {
    final platform = context.theme.platform;
    final matchingTransition = Get.theme.pageTransitionsTheme.builders[platform];
    switch (matchingTransition) {
      case CupertinoPageTransitionsBuilder():
        return Transition.cupertino;
      case ZoomPageTransitionsBuilder():
        return Transition.zoom;
      case FadeUpwardsPageTransitionsBuilder():
        return Transition.fade;
      case OpenUpwardsPageTransitionsBuilder():
        return Transition.native;
      default:
        return null;
    }
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    Get.asap(() {
      final locale = Get.deviceLocale;
      if (locale != null) {
        Get.updateLocale(locale);
      }
    });
  }

  void setTheme(ThemeData value) {
    if (config.darkTheme == null) {
      config = config.copyWith(theme: value);
    } else {
      if (value.brightness == Brightness.light) {
        config = config.copyWith(theme: value);
      } else {
        config = config.copyWith(darkTheme: value);
      }
    }
    update();
  }

  void setThemeMode(ThemeMode value) {
    config = config.copyWith(themeMode: value);
    update();
  }

  void restartApp() {
    config = config.copyWith(unikey: UniqueKey());
    update();
  }

  void update() {
    context.visitAncestorElements((element) {
      element.markNeedsBuild();
      return false;
    });
  }

  GlobalKey<NavigatorState> get key => rootDelegate.navigatorKey;

  GetDelegate get rootDelegate => config.routerDelegate as GetDelegate;

  RouteInformationParser<Object> get informationParser => config.routeInformationParser!;

  GlobalKey<NavigatorState>? addKey(GlobalKey<NavigatorState> newKey) {
    rootDelegate.navigatorKey = newKey;
    return key;
  }

  Map<String, GetDelegate> keys = {};

  GetDelegate? nestedKey(String? key) {
    if (key == null) {
      return rootDelegate;
    }
    keys.putIfAbsent(
      key,
      () => GetDelegate(
        showHashOnUrl: true,
        //debugLabel: 'Getx nested key: ${key.toString()}',
        pages: RouteDecoder.fromRoute(key).currentChildren ?? [],
      ),
    );
    return keys[key];
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  String cleanRouteName(String name) {
    name = name.replaceAll('() => ', '');

    /// uncomment for URL styling.
    // name = name.paramCase!;
    if (!name.startsWith('/')) {
      name = '/$name';
    }
    return Uri.tryParse(name)?.toString() ?? name;
  }
}
