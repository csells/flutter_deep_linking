// import 'package:collection/collection.dart' show IterableExtension;
// import 'package:flutter/material.dart';
// import 'data.dart';
// import 'main.dart';

// abstract class AppRouter {
//   bool matches(RouteSettings settings);
//   MaterialPageRoute? route(RouteSettings settings);

//   static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
//     final router = routers.firstWhereOrNull((r) => r.matches(settings));
//     return router != null
//         ? router.route(settings)
//         : MaterialPageRoute<dynamic>(settings: settings, builder: (_) => Four04Page('unknown route: ${settings.name}'));
//   }

//   static final routers = [
//     // start with most specific one first
//     PersonPageRouter(),
//     FamilyPageRouter(),
//     HomePageRouter(),
//   ];
// }

// class HomePageRouter extends AppRouter {
//   @override
//   bool matches(RouteSettings settings) => settings.name == null || settings.name!.isEmpty || settings.name == '/';

//   @override
//   MaterialPageRoute route(RouteSettings settings) =>
//       MaterialPageRoute<dynamic>(settings: settings, builder: (_) => const FamiliesPage());
// }

// class FamilyPageRouter extends AppRouter {
//   static final _routeRE = RegExp(r'^\/family\/(?<fid>[^\/]+)$');

//   @override
//   bool matches(RouteSettings settings) => settings.name!.startsWith('/family');

//   @override
//   MaterialPageRoute? route(RouteSettings settings) {
//     assert(matches(settings));
//     final match = _routeRE.firstMatch(settings.name!);
//     return match == null
//         ? null
//         : MaterialPageRoute<dynamic>(settings: settings, builder: (_) => FamilyPage(match.namedGroup('fid')));
//   }

//   static Future<T?> navigate<T>(BuildContext context, Family family) =>
//       Navigator.pushNamed<T>(context, '/family/${family.id}');
// }

// class PersonPageRouter extends AppRouter {
//   static final _routeRE = RegExp(r'^\/family\/(?<fid>[^\/]+)\/person\/(?<pid>[^\/]+)$');
//   @override
//   bool matches(RouteSettings settings) => settings.name!.startsWith('/family') && settings.name!.contains('/person');

//   @override
//   MaterialPageRoute? route(RouteSettings settings) {
//     assert(matches(settings));
//     final match = _routeRE.firstMatch(settings.name!);
//     return match == null
//         ? null
//         : MaterialPageRoute<dynamic>(
//             settings: settings, builder: (_) => PersonPage(match.namedGroup('fid'), match.namedGroup('pid')));
//   }

//   static Future<T?> navigate<T>(BuildContext context, Family family, Person person) =>
//       Navigator.pushNamed<T>(context, '/family/${family.id}/person/${person.id}');
// }
