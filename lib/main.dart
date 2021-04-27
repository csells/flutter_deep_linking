// import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'data.dart';

void main() => runApp(const App());

class App extends StatefulWidget {
  static const title = 'Flutter Deep Linking Demo';
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final _families = Families.data;
  Family? _selectedFamily;
  Person? _selectedPerson;
  // var _show404 = false;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: App.title,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Navigator(
          pages: [
            MaterialPage<dynamic>(
              key: const ValueKey('FamiliesPage'),
              child: FamiliesPage(
                families: _families,
                onTap: _familyTapped,
              ),
            ),
            // if (_show404)
            //   const MaterialPage<dynamic>(key: ValueKey('Four04Page'), child: Four04Page())
            // else {}
            if (_selectedFamily != null)
              MaterialPage<dynamic>(
                key: ValueKey(_selectedFamily),
                child: FamilyPage(
                  family: _selectedFamily!,
                  onTap: _personTapped,
                ),
              ),
            if (_selectedPerson != null)
              MaterialPage<dynamic>(
                key: ValueKey(_selectedPerson),
                child: PersonPage(
                  family: _selectedFamily!,
                  person: _selectedPerson!,
                ),
              ),
          ],
          onPopPage: (route, dynamic result) {
            if (!route.didPop(result)) return false;

            // NOTE: if you're more than one page deep, you need to decide which state to adjust
            final page = route.settings as MaterialPage<dynamic>;
            if (page.child is FamilyPage) {
              setState(() {
                _selectedFamily = null;
                _selectedPerson = null;
              });
            } else if (page.child is PersonPage) {
              setState(() {
                _selectedPerson = null;
              });
            }
            
            return true;
          },
        ),
      );

  void _familyTapped(Family family) => setState(() => _selectedFamily = family);
  void _personTapped(Person person) => setState(() => _selectedPerson = person);
}

class FamiliesPage extends StatelessWidget {
  final List<Family> families;
  final ValueChanged<Family> onTap;
  const FamiliesPage({required this.families, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(App.title)),
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
  const Four04Page({this.message = 'error', Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Page Not Found')),
        body: Center(child: Text(message)),
      );
}
