// from https://medium.com/flutter/learning-flutters-new-navigation-and-routing-system-7c9068155ade
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:path_to_regexp/path_to_regexp.dart' as p2re;
import 'data.dart';
import 'pages.dart';

class RouteMatch {
  late final bool isMatch;
  late final Map<String, String> args;
  RouteMatch(String routePattern, String route) {
    final parameters = <String>[];
    final re = p2re.pathToRegExp(routePattern, prefix: true, caseSensitive: false, parameters: parameters);
    final match = re.matchAsPrefix(route);
    isMatch = match != null;
    if (match != null) args = p2re.extract(parameters, match);
  }
}

class RoutePage {
  final String route;
  final Page<dynamic> page;

  RoutePage({required this.route, required this.page}) {
    Uri.parse(route);
  }
}

class UriRouterDelegate extends RouterDelegate<Uri>
    with
        PopNavigatorRouterDelegateMixin<Uri>,
        // ignore: prefer_mixin
        ChangeNotifier {
  final _families = Families.data;
  Uri _uri = Uri.parse('/');
  final _key = GlobalKey<NavigatorState>();
  _Stack<Uri>? _routesForPopping;

  @override
  GlobalKey<NavigatorState> get navigatorKey => _key;

  @override
  Uri get currentConfiguration => _uri;

  void go(String route) {
    _uri = Uri.parse(route);
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    final routePages = <RoutePage>[];
    String? four04message;
    String? routePattern;
    final route = _uri.toString();
    RouteMatch routeMatch;

    routePattern = '/';
    routeMatch = RouteMatch(routePattern, route);
    if (routeMatch.isMatch) {
      final args = routeMatch.args;
      routePages.add(
        RoutePage(
          route: p2re.pathToFunction(routePattern)(args),
          page: MaterialPage<FamiliesPage>(
            key: const ValueKey('FamiliesPage'),
            child: FamiliesPage(
              families: _families,
            ),
          ),
        ),
      );
    }

    routePattern = '/family/:fid';
    routeMatch = RouteMatch(routePattern, route);
    if (routeMatch.isMatch) {
      final args = routeMatch.args;
      final family = _families.singleWhereOrNull((f) => f.id == args['fid']);

      if (family == null) {
        four04message = 'unknown family ${args['fid']}';
      } else {
        routePages.add(
          RoutePage(
            route: p2re.pathToFunction(routePattern)(args),
            page: MaterialPage<FamilyPage>(
              key: ValueKey(family),
              child: FamilyPage(
                family: family,
              ),
            ),
          ),
        );
      }
    }

    routePattern = '/family/:fid/person/:pid';
    routeMatch = RouteMatch(routePattern, route);
    if (routeMatch.isMatch) {
      final args = routeMatch.args;
      final family = _families.singleWhereOrNull((f) => f.id == args['fid']);
      final person = family?.people.singleWhereOrNull((p) => p.id == args['pid']);

      if (family == null) {
        four04message = 'unknown family ${args['fid']}';
      } else if (person == null) {
        four04message = 'unknown person ${args['pid']} for family ${args['fid']}';
      } else {
        routePages.add(
          RoutePage(
            route: p2re.pathToFunction(routePattern)(args),
            page: MaterialPage<PersonPage>(
              key: ValueKey(person),
              child: PersonPage(
                family: family,
                person: person,
              ),
            ),
          ),
        );
      }
    }

    if (four04message != null) {
      routePages.clear();
      routePages.add(
        RoutePage(
          route: route,
          page: MaterialPage<Four04Page>(
            key: const ValueKey('Four04Page'),
            child: Four04Page(
              message: four04message,
            ),
          ),
        ),
      );
    }

    _routesForPopping = _Stack<Uri>([for (final rp in routePages) Uri.parse(rp.route)]);
    final pages = [for (final rp in routePages) rp.page];

    return _InheritedUriRouterDelegate(
      state: this,
      child: Navigator(
        pages: pages,
        onPopPage: (route, dynamic result) {
          if (!route.didPop(result)) return false;

          assert(_routesForPopping != null);
          assert(_routesForPopping!.depth >= 1);
          _routesForPopping!.pop(); // remove the route for the page we're showing
          _uri = _routesForPopping!.top; // set the route for the next page down
          notifyListeners();

          return true;
        },
      ),
    );
  }

  @override
  Future<void> setNewRoutePath(Uri configuration) async {
    _uri = configuration;
  }

  static UriRouterDelegate of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_InheritedUriRouterDelegate>()!.state;
}

class UriRouteInformationParser extends RouteInformationParser<Uri> {
  @override
  Future<Uri> parseRouteInformation(RouteInformation routeInformation) async =>
      Uri.parse(routeInformation.location ?? '/');

  @override
  RouteInformation restoreRouteInformation(Uri configuration) => RouteInformation(location: configuration.toString());
}

class _InheritedUriRouterDelegate extends InheritedWidget {
  final UriRouterDelegate state;
  const _InheritedUriRouterDelegate({required Widget child, required this.state, Key? key})
      : super(child: child, key: key);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}

class _Stack<T> {
  final _queue = Queue<T>();

  _Stack(Iterable<T>? init) {
    if (init != null) _queue.addAll(init);
  }

  void push(T element) => _queue.addLast(element);
  T get top => _queue.last;
  int get depth => _queue.length;
  T pop() => _queue.removeLast();
  void clear() => _queue.clear();
  bool get isEmpty => _queue.isEmpty;
  bool get isNotEmpty => _queue.isNotEmpty;
}
