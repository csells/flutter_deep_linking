import 'package:flutter/material.dart';

import 'data.dart';
import 'go_router.dart';
import 'pages.dart';

class Routing {
  // home page shows a list of families
  static final _familiesInfo = GoRoute(
    pattern: '/',
    builder: (context, args) => MaterialPage<FamiliesPage>(
      key: const ValueKey('FamiliesPage'),
      child: FamiliesPage(
        families: Families.data,
      ),
    ),
  );

  // family page shows a single family
  static final _familyInfo = GoRoute(
    pattern: '/family/:fid',
    builder: (context, args) {
      final family = Families.data.singleWhere(
        (f) => f.id == args['fid'],
        orElse: () => throw Exception('unknown family ${args['fid']}'),
      );

      return MaterialPage<FamilyPage>(
        key: ValueKey(family),
        child: FamilyPage(
          family: family,
        ),
      );
    },
  );

  // person page shows a person from a family
  static final _personInfo = GoRoute(
    pattern: '/family/:fid/person/:pid',
    builder: (context, args) {
      final family = Families.data.singleWhere(
        (f) => f.id == args['fid'],
        orElse: () => throw Exception('unknown family ${args['fid']}'),
      );

      final person = family.people.singleWhere(
        (p) => p.id == args['pid'],
        orElse: () => throw Exception('unknown person ${args['pid']} for family ${args['fid']}'),
      );

      return MaterialPage<PersonPage>(
        key: ValueKey(person),
        child: PersonPage(
          family: family,
          person: person,
        ),
      );
    },
  );

  // mapping route patterns to specific pages
  static final router = GoRouter.routes(
    routes: [
      _familiesInfo,
      _familyInfo,
      _personInfo,
    ],
  );

  // e.g. context.go(routing.forFamilies)
  static String forFamilies() => _familiesInfo.pattern;

  // e.g. context.go(routing.forFamily(family: family))
  static String forFamily({required Family family}) => GoRouter.routePath(_familyInfo.pattern, {'fid': family.id});

  // e.g. context.go(routing.forPerson(family: family, person: person))
  static String forPerson({required Family family, required Person person}) =>
      GoRouter.routePath(_personInfo.pattern, {'fid': family.id, 'pid': person.id});
}
