import 'package:flutter/material.dart';
import 'routing.dart' as routing;

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routeInformationParser: routing.routeInformationParser,
        routerDelegate: routing.routerDelegate,
        title: 'Flutter Deep Linking Demo',
      );
}
