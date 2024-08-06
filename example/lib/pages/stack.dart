import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vibe/vibe.dart';

abstract class VibeStack {
  void Function()? get onPopRequest => null;
}

class HomeStack extends VibeStack {
  HomeStack({
    this.onPopRequest,
    this.child,
  });
  @override
  final void Function()? onPopRequest;
  final VibeStack? child;
}

@WithVibe([])
class RootStack extends VibeStack {
  VibeStack build(BuildContext context) {
    return HomeStack(
      onPopRequest: () {},
      child: HomeStack(),
    );
  }
}

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
  Widget build(BuildContext context) {
    return const Placeholder();
  }

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
