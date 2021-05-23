// from https://medium.com/flutter/learning-flutters-new-navigation-and-routing-system-7c9068155ade
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:path_to_regexp/path_to_regexp.dart';
import 'data.dart';
import 'pages.dart';

class RouteMatch {
  late final bool matches;
  late final Map<String, String> args;
  RouteMatch(String routePattern, String route) {
    final parameters = <String>[];
    final re = pathToRegExp(routePattern, prefix: true, caseSensitive: false, parameters: parameters);
    final match = re.matchAsPrefix(route);
    matches = match != null;
    if (match != null) args = extract(parameters, match);
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
    final pages = <Page<dynamic>>[];
    String? four04message;
    final route = _uri.toString();
    RouteMatch routeMatch;

    routeMatch = RouteMatch('/', route);
    if (routeMatch.matches) {
      pages.add(
        MaterialPage<FamiliesPage>(
          key: const ValueKey('FamiliesPage'),
          child: FamiliesPage(
            families: _families,
          ),
        ),
      );
    }

    routeMatch = RouteMatch('/family/:fid', route);
    if (routeMatch.matches) {
      final args = routeMatch.args;
      final family = _families.singleWhereOrNull((f) => f.id == args['fid']);
      if (family == null) {
        four04message = 'unknown family ${args['fid']}';
      } else {
        pages.add(
          MaterialPage<FamilyPage>(
            key: ValueKey(family),
            child: FamilyPage(
              family: family,
            ),
          ),
        );
      }
    }

    routeMatch = RouteMatch('/family/:fid/person/:pid', route);
    if (routeMatch.matches) {
      final args = routeMatch.args;
      final family = _families.singleWhereOrNull((f) => f.id == args['fid']);
      final person = family?.people.singleWhereOrNull((p) => p.id == args['pid']);
      if (family == null) {
        four04message = 'unknown family ${args['fid']}';
      } else if (person == null) {
        four04message = 'unknown person ${args['pid']} for family ${args['fid']}';
      } else {
        pages.add(
          MaterialPage<PersonPage>(
            key: ValueKey(person),
            child: PersonPage(
              family: family,
              person: person,
            ),
          ),
        );
      }
    }

    if (four04message != null) {
      pages.clear();
      pages.add(
        MaterialPage<Four04Page>(
          key: const ValueKey('Four04Page'),
          child: Four04Page(
            message: four04message,
          ),
        ),
      );
    }

    return _InheritedUriRouterDelegate(
      state: this,
      child: Navigator(
        pages: pages,
        onPopPage: (route, dynamic result) {
          if (!route.didPop(result)) return false;
          // TODO: something!
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
