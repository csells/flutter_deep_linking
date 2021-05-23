import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:path_to_regexp/path_to_regexp.dart' as p2re;

typedef UriRouteInfoBuilder = List<UriRouteInfo> Function(BuildContext context);
typedef UriRoutePageBuilder = Page<dynamic> Function(BuildContext context, Map<String, String> args);

class UriRouteInfo {
  final String routePattern;
  final UriRoutePageBuilder builder;
  UriRouteInfo({required this.routePattern, required this.builder});
}

class UriRouter {
  UriRouteInfoBuilder builder;
  final _routeInformationParser = _UriRouteInformationParser();
  late final _UriRouterDelegate _routerDelegate;
  UriRouter({required this.builder}) {
    _routerDelegate = _UriRouterDelegate(uriRouter: this);
  }

  RouteInformationParser<Object> get routeInformationParser => _routeInformationParser;
  RouterDelegate<Object> get routerDelegate => _routerDelegate;

  static UriRouter of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<_InheritedUriRouter>()!.state;

  void go(String route) {
    _routerDelegate.go(route);
  }
}

class _UriRouterDelegate extends RouterDelegate<Uri>
    with
        PopNavigatorRouterDelegateMixin<Uri>,
        // ignore: prefer_mixin
        ChangeNotifier {
  Uri _uri = Uri.parse('/');
  final _key = GlobalKey<NavigatorState>();
  _Stack<Uri>? _routesForPopping;
  final UriRouter uriRouter;

  _UriRouterDelegate({required this.uriRouter});

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
    final routePages = <_RoutePageInfo>[];
    final route = _uri.toString().trim();
    String? error;
    final infos = uriRouter.builder(context);

    for (final info in infos) {
      final params = <String>[];
      final re = p2re.pathToRegExp(info.routePattern, prefix: true, caseSensitive: false, parameters: params);
      final match = re.matchAsPrefix(route);
      if (match == null) continue;
      final args = p2re.extract(params, match);

      final routeFromPattern = p2re.pathToFunction(info.routePattern)(args);
      try {
        final page = info.builder(context, args);
        routePages.add(_RoutePageInfo(route: routeFromPattern, page: page));
      } on Exception catch (ex) {
        // if can't add a page from their args, show an error
        error = ex.toString();
        break;
      }
    }

    // if the last route doesn't match exactly, then we haven't got a valid stack of pages
    // this allows '/' to match as part of a stack of pages but to fail w/ '/nonsense'
    if (route.toLowerCase() != routePages.last.route.toLowerCase()) routePages.clear();

    // if no pages found, show an error
    if (routePages.isEmpty) error = 'page not found: $route';

    // if there's an error, show an error page
    if (error != null) {
      routePages.clear();
      routePages.add(
        _RoutePageInfo(
          route: route,
          page: MaterialPage<_ErrorPage>(
            key: const ValueKey('_ErrorPage'),
            child: _ErrorPage(message: error), // TODO: make this replaceable
          ),
        ),
      );
    }

    _routesForPopping = _Stack<Uri>([for (final rp in routePages) Uri.parse(rp.route)]);
    final pages = [for (final rp in routePages) rp.page];

    return _InheritedUriRouter(
      state: uriRouter,
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
        // TODO: this almost works! I don't know why the Container stays in the stack of pages...
        // Doesn't the call to notifyListeners() cause the whole Navigation stack to be rebuilt??
        // Hmmm... I be the AppBar back button works just fine but the browser back button remembers...
        // NOTE: this enables Navigator.pushNamed(context, '/family/${f.id}'),
        // onGenerateRoute: (settings) {
        //   _uri = Uri.parse(settings.name ?? '/');
        //   notifyListeners();
        //   return MaterialPageRoute<Container>(builder: (context) => Container());
        // },
      ),
    );
  }

  @override
  Future<void> setNewRoutePath(Uri configuration) async {
    _uri = configuration;
  }
}

class _UriRouteInformationParser extends RouteInformationParser<Uri> {
  @override
  Future<Uri> parseRouteInformation(RouteInformation routeInformation) async =>
      Uri.parse(routeInformation.location ?? '/');

  @override
  RouteInformation restoreRouteInformation(Uri configuration) => RouteInformation(location: configuration.toString());
}

class _InheritedUriRouter extends InheritedWidget {
  final UriRouter state;
  const _InheritedUriRouter({required Widget child, required this.state, Key? key}) : super(child: child, key: key);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}

class _RoutePageInfo {
  final String route;
  final Page<dynamic> page;
  _RoutePageInfo({required this.route, required this.page}) {
    Uri.parse(route);
  }
}

class _Stack<T> {
  final _queue = Queue<T>();

  _Stack([Iterable<T>? init]) {
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

class _ErrorPage extends StatelessWidget {
  final String message;
  const _ErrorPage({required this.message, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Navigation Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(message),
              TextButton(
                onPressed: () => UriRouter.of(context).go('/'),
                child: const Text('Home'),
              ),
            ],
          ),
        ),
      );
}
