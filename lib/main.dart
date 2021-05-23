import 'package:flutter/material.dart';
import 'routing.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routeInformationParser: UriRouteInformationParser(),
        routerDelegate: UriRouterDelegate(),
        title: 'Flutter Deep Linking Demo',
      );
}
