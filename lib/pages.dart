import 'package:flutter/material.dart';
import 'package:nav_stack/nav_stack.dart';
import 'data.dart';

class FamiliesPage extends StatelessWidget {
  final List<Family> families;
  const FamiliesPage({required this.families, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Flutter Deep Linking Demo')),
        body: ListView(
          children: [
            for (final f in families)
              ListTile(title: Text(f.name), onTap: () => NavStack.of(context).path = '/family/${f.id}')
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
                  title: Text(p.name), onTap: () => NavStack.of(context).path = '/family/${family.id}/person/${p.id}')
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
      appBar: AppBar(title: Text(person.name)), body: Text('${person.name} ${family.name} is ${person.age} years old'));
}

class Four04Page extends StatelessWidget {
  final String message;
  const Four04Page({required this.message, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Page Not Found')),
        body: Center(child: Text(message)),
      );
}
