import 'package:flutter/material.dart';
import 'data.dart';

class HomePage extends StatelessWidget {
  final List<Family> families;
  final ValueChanged<Family> onTap;
  const HomePage({required this.families, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Flutter Deep Linking Demo')),
        body: ListView(
          children: [for (final f in families) ListTile(title: Text(f.name), onTap: () => onTap(f))],
        ),
      );
}

class FamilyPage extends StatelessWidget {
  final Family family;
  final ValueChanged<Person> onTap;
  const FamilyPage({required this.family, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(family.name)),
        body: ListView(
          children: [for (final p in family.people) ListTile(title: Text(p.name), onTap: () => onTap(p))],
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
