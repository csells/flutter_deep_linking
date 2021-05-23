import 'package:flutter/material.dart';

import 'data.dart';
import 'go_router.dart';
import 'pages.dart';

// home page shows a list of families
final _familiesInfo = GoRoute(
  pattern: '/',
  builder: (context, args) => MaterialPage<FamiliesPage>(
    key: const ValueKey('FamiliesPage'),
    child: FamiliesPage(
      families: Families.data,
    ),
  ),
);

// e.g. context.go(Routing.forFamilies())
String forFamilies() => _familiesInfo.pattern;

// family page shows a single family
final _familyInfo = GoRoute(
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

// e.g. context.go(Routing.forFamily(family: family))
String forFamily({required Family family}) => GoRouter.routePath(_familyInfo.pattern, {'fid': family.id});

// person page shows a person from a family
final _personInfo = GoRoute(
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

// e.g. context.go(Routing.forPerson(family: family, person: person))
String forPerson({required Family family, required Person person}) =>
    GoRouter.routePath(_personInfo.pattern, {'fid': family.id, 'pid': person.id});

// mapping route patterns to specific pages
final _router = GoRouter.routes(
  routes: [
    _familiesInfo,
    _familyInfo,
    _personInfo,
  ],
  error: (context, args) => MaterialPage<Four04Page>(
    key: const ValueKey('ErrorPage'),
    child: Four04Page(message: args['message']!),
  ),
);

RouteInformationParser<Object> get routeInformationParser => _router.routeInformationParser;
RouterDelegate<Object> get routerDelegate => _router.routerDelegate;
