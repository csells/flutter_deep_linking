import 'package:flutter/material.dart';

import 'data.dart';
import 'go_router.dart';
import 'pages.dart';

// home page shows a list of families
final _familiesInfo = GoRouteInfo(
  routePattern: '/',
  builder: (context, args) => MaterialPage<FamiliesPage>(
    key: const ValueKey('FamiliesPage'),
    child: FamiliesPage(
      families: Families.data,
    ),
  ),
);

// e.g. context.go(routing.forFamilies)
String forFamilies() => _familiesInfo.routePattern;

// family page shows a single family
final _familyInfo = GoRouteInfo(
  routePattern: '/family/:fid',
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

// e.g. context.go(routing.forFamily(family: family))
String forFamily({required Family family}) => GoRouter.routePath(_familyInfo.routePattern, {'fid': family.id});

// person page shows a person from a family
final _personInfo = GoRouteInfo(
  routePattern: '/family/:fid/person/:pid',
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

// e.g. context.go(routing.forPerson(family: family, person: person))
String forPerson({required Family family, required Person person}) =>
    GoRouter.routePath(_personInfo.routePattern, {'fid': family.id, 'pid': person.id});

// mapping route patterns to specific pages
final routes = <GoRouteInfo>[
  _familiesInfo,
  _familyInfo,
  _personInfo,
];
