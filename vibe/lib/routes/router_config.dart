import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VibeRouterConfig implements RouterConfig {
  VibeRouterConfig() {
    backButtonDispatcher = RootBackButtonDispatcher();
    routeInformationParser = VibeRouteInformationParser();
    routeInformationProvider = VibeRouteInformationProvier();
    routerDelegate = VibeRouterDelegate();
  }

  @override
  late final BackButtonDispatcher? backButtonDispatcher;

  @override
  // TODO: implement routeInformationParser
  late final RouteInformationParser routeInformationParser;

  @override
  late final RouteInformationProvider routeInformationProvider;

  @override
  late final RouterDelegate routerDelegate;
}

class VibeRouteInformationProvier extends RouteInformationProvider {
  @override
  void addListener(VoidCallback listener) {
    // TODO: implement addListener
  }

  @override
  void removeListener(VoidCallback listener) {
    // TODO: implement removeListener
  }

  @override
  // TODO: implement value
  RouteInformation get value => throw UnimplementedError();
}

class VibeRouteInformationParser extends RouteInformationParser {
  @override
  Future parseRouteInformationWithDependencies(
    RouteInformation routeInformation,
    BuildContext context,
  ) {
    //
    return super
        .parseRouteInformationWithDependencies(routeInformation, context);
  }
}

class VibeRouterDelegate extends RouterDelegate
    with PopNavigatorRouterDelegateMixin {
  @override
  void addListener(VoidCallback listener) {
    // TODO: implement addListener
  }

  @override
  Widget build(BuildContext context) => const Placeholder();

  @override
  Future<bool> popRoute() {
    // TODO: implement popRoute
    throw UnimplementedError();
  }

  @override
  void removeListener(VoidCallback listener) {
    // TODO: implement removeListener
  }

  @override
  Future<void> setNewRoutePath(configuration) {
    // TODO: implement setNewRoutePath
    throw UnimplementedError();
  }

  @override
  // TODO: implement navigatorKey
  GlobalKey<NavigatorState>? get navigatorKey => throw UnimplementedError();
}
