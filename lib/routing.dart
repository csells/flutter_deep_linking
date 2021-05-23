import 'package:flutter/material.dart';

import 'data.dart';
import 'pages.dart';
import 'uri_router.dart';

List<UriRouteInfo> routeBuilder(BuildContext context) => <UriRouteInfo>[
      // home page shows a list of families
      UriRouteInfo(
        routePattern: '/',
        builder: (context, args) => MaterialPage<FamiliesPage>(
          key: const ValueKey('FamiliesPage'),
          child: FamiliesPage(
            families: Families.data,
          ),
        ),
      ),

      // family page shows a single family
      UriRouteInfo(
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
      ),

      // person page shows a person from a family
      UriRouteInfo(
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
      ),
    ];
