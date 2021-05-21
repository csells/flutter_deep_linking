import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:nav_stack/nav_stack.dart';
import 'data.dart';
import 'pages.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  final families = Families.data;
  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routeInformationParser: NavStackParser(),
        routerDelegate: NavStackDelegate(
          onGenerateStack: (context, nav) => PathStack(
            routes: {
              const ['/']: StackRouteBuilder(
                builder: (context, args) => FamiliesPage(families: families),
              ),
              const ['/family/:fid']: StackRouteBuilder(
                builder: (context, args) {
                  final fid = args['fid'];
                  final family = families.singleWhereOrNull((f) => f.id == fid);
                  if (family == null) return Four04Page(message: 'unknown family $fid');

                  return FamilyPage(family: family);
                },
              ),
              const ['/family/:fid/person/:pid']: StackRouteBuilder(
                builder: (context, args) {
                  final fid = args['fid'];
                  final family = families.singleWhereOrNull((f) => f.id == fid);
                  if (family == null) return Four04Page(message: 'unknown family $fid');

                  final pid = args['pid'];
                  final person = family.people.singleWhereOrNull((p) => p.id == pid);
                  if (person == null) return Four04Page(message: 'unknown person $pid for family $fid');

                  return PersonPage(family: family, person: person);
                },
              ),
            },
          ),
        ),
        title: 'Flutter Deep Linking Demo',
      );
}
