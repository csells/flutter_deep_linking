import 'package:flutter/material.dart';

import 'go_router.dart';
import 'routing.dart' as routing;

void main() => runApp(App());

class App extends StatelessWidget {
  final GoRouter router = GoRouter.routes(routes: routing.routes);
  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
        title: 'Flutter Deep Linking Demo',
      );
}
