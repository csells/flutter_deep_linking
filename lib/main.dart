import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  static final title = 'Flutter Web Deep Linking Demo';
  static final families = [
    Family(
      id: 'f1',
      name: 'Sells',
      people: [
        Person(id: 'p1', name: 'Chris', age: 50),
        Person(id: 'p2', name: 'John', age: 25),
        Person(id: 'p3', name: 'Tom', age: 24),
      ],
    ),
    Family(
      id: 'f2',
      name: 'Addams',
      people: [
        Person(id: 'p1', name: 'Gomez', age: 55),
        Person(id: 'p2', name: 'Morticia', age: 50),
        Person(id: 'p3', name: 'Pugsley', age: 10),
        Person(id: 'p4', name: 'Wednesday', age: 17),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: title,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: HomePage(),
        onGenerateRoute: (settings) {
          final parts = settings.name.split('?');
          final args = parts.length == 2 ? Uri.splitQueryString(parts[1]) : null;
          switch (parts[0]) {
            case '/':
              return MaterialPageRoute(settings: settings, builder: (_) => HomePage());

            case '/family':
              final family =
                  App.families.singleWhere((f) => f.id == args['fid'], orElse: () => null);
              if (family == null)
                return MaterialPageRoute(
                    settings: settings,
                    builder: (_) => Four04Page('unknown family: ${args["fid"]}'));
              return MaterialPageRoute(settings: settings, builder: (_) => FamilyPage(family));

            case '/person':
              final family =
                  App.families.singleWhere((f) => f.id == args['fid'], orElse: () => null);
              if (family == null)
                return MaterialPageRoute(
                    settings: settings,
                    builder: (_) => Four04Page('unknown family: ${args["fid"]}'));
              final person =
                  family.people.singleWhere((p) => p.id == args['pid'], orElse: () => null);
              if (person == null)
                return MaterialPageRoute(
                    settings: settings,
                    builder: (_) => Four04Page('unknown person: ${args["pid"]}'));

              return MaterialPageRoute(
                  settings: settings, builder: (_) => PersonPage(family, person));

            default:
              return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => Four04Page('unknown route: ${settings.name}'));
          }
        },
      );
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(App.title)),
        body: ListView(
          children: App.families
              .map((f) => ListTile(
                  title: Text(f.name),
                  onTap: () => Navigator.pushNamed(context, '/family?fid=${f.id}')))
              .toList(),
        ),
      );
}

class FamilyPage extends StatelessWidget {
  final Family family;
  FamilyPage(this.family);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(family.name)),
        body: ListView(
          children: family.people
              .map((p) => ListTile(
                  title: Text(p.name),
                  onTap: () =>
                      Navigator.pushNamed(context, '/person?fid=${family.id}&pid=${p.id}')))
              .toList(),
        ),
      );
}

class PersonPage extends StatelessWidget {
  final Family family;
  final Person person;
  PersonPage(this.family, this.person);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(person.name)),
        body: Center(child: Text('${person.name} ${family.name} is ${person.age} years old')),
      );
}

class Four04Page extends StatelessWidget {
  final String message;
  Four04Page(this.message);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Page Not Found')),
        body: Center(child: Text(message)),
      );
}

class Person {
  final String id;
  final String name;
  final int age;
  Person({@required this.id, this.name, this.age});
}

class Family {
  final String id;
  final String name;
  final List<Person> people;
  Family({@required this.id, this.name, this.people});
}
