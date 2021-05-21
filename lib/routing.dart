// // from https://medium.com/flutter/learning-flutters-new-navigation-and-routing-system-7c9068155ade
// import 'package:flutter/material.dart';
// import 'package:collection/collection.dart';
// import 'data.dart';
// import 'pages.dart';

// enum AppRouteConfigKind { unknown, home, family, person }

// class AppRouteConfig {
//   final AppRouteConfigKind kind;
//   final String? fid;
//   final String? pid;
//   final String? message;

//   AppRouteConfig.unknown({this.message = 'error'})
//       : kind = AppRouteConfigKind.unknown,
//         fid = null,
//         pid = null;

//   AppRouteConfig.home()
//       : kind = AppRouteConfigKind.home,
//         fid = null,
//         pid = null,
//         message = null;

//   AppRouteConfig.family({required this.fid})
//       : kind = AppRouteConfigKind.family,
//         pid = null,
//         message = null;

//   AppRouteConfig.person({required this.fid, required this.pid})
//       : kind = AppRouteConfigKind.person,
//         message = null;
// }

// class AppRouterDelegate extends RouterDelegate<AppRouteConfig>
//     with
//         PopNavigatorRouterDelegateMixin<AppRouteConfig>,
//         // ignore: prefer_mixin
//         ChangeNotifier {
//   final _families = Families.data;
//   Family? _selectedFamily;
//   Person? _selectedPerson;
//   // ignore: non_constant_identifier_names
//   String? _404message;

//   @override
//   final navigatorKey = GlobalKey<NavigatorState>();

//   @override
//   AppRouteConfig get currentConfiguration => _404message != null
//       ? AppRouteConfig.unknown()
//       : _selectedPerson != null
//           ? AppRouteConfig.person(fid: _selectedFamily!.id, pid: _selectedPerson!.id)
//           : _selectedFamily != null
//               ? AppRouteConfig.family(fid: _selectedFamily!.id)
//               : AppRouteConfig.home();

//   @override
//   Widget build(BuildContext context) => Navigator(
//         pages: [
//           MaterialPage<dynamic>(
//             key: const ValueKey('FamiliesPage'),
//             child: FamiliesPage(
//               families: _families,
//               onTap: _familyTapped,
//             ),
//           ),
//           if (_404message != null)
//             MaterialPage<Four04Page>(
//               key: const ValueKey('Four04Page'),
//               child: Four04Page(
//                 message: _404message!,
//               ),
//             )
//           else if (_selectedFamily != null)
//             MaterialPage<FamilyPage>(
//               key: ValueKey(_selectedFamily),
//               child: FamilyPage(
//                 family: _selectedFamily!,
//                 onTap: _personTapped,
//               ),
//             ),
//           if (_selectedPerson != null)
//             MaterialPage<PersonPage>(
//               key: ValueKey(_selectedPerson),
//               child: PersonPage(
//                 family: _selectedFamily!,
//                 person: _selectedPerson!,
//               ),
//             ),
//         ],
//         onPopPage: (route, dynamic result) {
//           if (!route.didPop(result)) return false;

//           // NOTE: if you're more than one page deep, you need to decide which state to adjust
//           if (route.settings is MaterialPage<FamilyPage>) {
//             _selectedFamily = null;
//             _selectedPerson = null;
//             notifyListeners();
//           } else if (route.settings is MaterialPage<PersonPage>) {
//             _selectedPerson = null;
//             notifyListeners();
//           }

//           return true;
//         },
//       );

//   void _familyTapped(Family family) {
//     _selectedFamily = family;
//     notifyListeners();
//   }

//   void _personTapped(Person person) {
//     _selectedPerson = person;
//     notifyListeners();
//   }

//   @override
//   Future<void> setNewRoutePath(AppRouteConfig configuration) async {
//     switch (configuration.kind) {
//       case AppRouteConfigKind.unknown:
//         _selectedFamily = null;
//         _selectedPerson = null;
//         _404message = null;
//         break;
//       case AppRouteConfigKind.home:
//         _selectedFamily = null;
//         _selectedPerson = null;
//         _404message = null;
//         break;
//       case AppRouteConfigKind.family:
//         _selectedFamily = _families.singleWhereOrNull((f) => f.id == configuration.fid);
//         _selectedPerson = null;
//         _404message = _selectedFamily == null ? 'unknown fid ${configuration.fid}' : null;
//         break;
//       case AppRouteConfigKind.person:
//         _selectedFamily = _families.singleWhereOrNull((f) => f.id == configuration.fid);
//         _selectedPerson = _selectedFamily?.people.singleWhereOrNull((p) => p.id == configuration.pid);
//         _404message = _selectedFamily == null
//             ? 'unknown fid ${configuration.fid}'
//             : _selectedPerson == null
//                 ? 'unknown pid ${configuration.pid}'
//                 : null;
//         break;
//     }
//   }
// }

// class AppRouteInformationParser extends RouteInformationParser<AppRouteConfig> {
//   @override
//   Future<AppRouteConfig> parseRouteInformation(RouteInformation routeInformation) async {
//     final uri = Uri.parse(routeInformation.location ?? '/');

//     // Handle '/'
//     if (uri.pathSegments.isEmpty) return AppRouteConfig.home();

//     // Handle '/family/:id'
//     if (uri.pathSegments.length == 2) {
//       if (uri.pathSegments[0] != 'family') return AppRouteConfig.unknown();

//       final fid = uri.pathSegments[1];
//       if (fid.isEmpty) return AppRouteConfig.unknown();

//       return AppRouteConfig.family(fid: fid);
//     }

//     // Handle '/family/:id/person/:id'
//     if (uri.pathSegments.length == 4) {
//       if (uri.pathSegments[0] != 'family') return AppRouteConfig.unknown();

//       final fid = uri.pathSegments[1];
//       if (fid.isEmpty) return AppRouteConfig.unknown();

//       if (uri.pathSegments[2] != 'person') return AppRouteConfig.unknown();

//       final pid = uri.pathSegments[3];
//       if (pid.isEmpty) return AppRouteConfig.unknown();

//       return AppRouteConfig.person(fid: fid, pid: pid);
//     }

//     // Handle unknown routes
//     return AppRouteConfig.unknown();
//   }

//   @override
//   RouteInformation restoreRouteInformation(AppRouteConfig configuration) {
//     switch (configuration.kind) {
//       case AppRouteConfigKind.unknown:
//         return const RouteInformation(location: '/404');
//       case AppRouteConfigKind.home:
//         return const RouteInformation(location: '/');
//       case AppRouteConfigKind.family:
//         return RouteInformation(location: '/family/${configuration.fid}');
//       case AppRouteConfigKind.person:
//         return RouteInformation(location: '/family/${configuration.fid}/person/${configuration.pid}');
//     }
//   }
// }
