// ignore_for_file: deprecated_member_use

import 'package:flutter/widgets.dart';

import '../../../../getx.dart';

class GetNavigator extends Navigator {
  GetNavigator.onGenerateRoute({
    GlobalKey<NavigatorState>? super.key,
    bool Function(Route<dynamic>, dynamic)? onPopPage,
    required List<GetPage> super.pages,
    List<NavigatorObserver>? observers,
    super.reportsRouteUpdateToEngine,
    TransitionDelegate? transitionDelegate,
    super.initialRoute,
    super.restorationScopeId,
  }) : super(
          //keys should be optional
          onPopPage: onPopPage ??
              (Route<dynamic> route, dynamic result) {
                if (route.didPop(result)) {
                  return true;
                }
                return false;
              },
          onGenerateRoute: (settings) {
            final selectedPageList = pages.where((element) => element.name == settings.name);
            if (selectedPageList.isNotEmpty) {
              final selectedPage = selectedPageList.first;
              return GetPageRoute(
                page: selectedPage.page,
                settings: settings,
              );
            }
            return null;
          },
          observers: [
            // GetObserver(),
            ...?observers,
          ],
          transitionDelegate: transitionDelegate ?? const DefaultTransitionDelegate<dynamic>(),
        );

  GetNavigator({
    super.key,
    bool Function(Route<dynamic>, dynamic)? onPopPage,
    required List<GetPage> super.pages,
    List<NavigatorObserver>? observers,
    super.reportsRouteUpdateToEngine,
    TransitionDelegate? transitionDelegate,
    super.initialRoute,
    super.restorationScopeId,
  }) : super(
          //keys should be optional
          onPopPage: onPopPage ??
              (Route<dynamic> route, dynamic result) {
                if (route.didPop(result)) {
                  return true;
                }
                return false;
              },
          observers: [
            // GetObserver(null, Get.routing),
            HeroController(),
            ...?observers,
          ],
          transitionDelegate: transitionDelegate ?? const DefaultTransitionDelegate<dynamic>(),
        );
}
