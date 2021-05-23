import 'package:flutter/material.dart';

import 'routing.dart' as routing;
import 'uri_router.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  final UriRouter router = UriRouter.routes(routes: routing.routes);
  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
        title: 'Flutter Deep Linking Demo',
      );
}
