import 'package:flutter/material.dart';
import 'data.dart';
import 'uri_router.dart';

class FamiliesPage extends StatelessWidget {
  final List<Family> families;
  const FamiliesPage({required this.families, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Flutter Deep Linking Demo')),
        body: ListView(
          children: [
            for (final f in families)
              ListTile(
                title: Text(f.name),
                onTap: () => UriRouter.of(context).go('/family/${f.id}'),
              )
          ],
        ),
      );
}

class FamilyPage extends StatelessWidget {
  final Family family;
  const FamilyPage({required this.family, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(family.name)),
        body: ListView(
          children: [
            for (final p in family.people)
              ListTile(
                title: Text(p.name),
                onTap: () => UriRouter.of(context).go('/family/${family.id}/person/${p.id}'),
              ),
          ],
        ),
      );
}

class PersonPage extends StatelessWidget {
  final Family family;
  final Person person;
  const PersonPage({required this.family, required this.person, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(person.name)),
        body: Text('${person.name} ${family.name} is ${person.age} years old'),
      );
}
