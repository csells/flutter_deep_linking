import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  static final title = 'Flutter Web Deep Linking Demo';

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: title,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: HomePage(),
        onGenerateRoute: (settings) {
          final args = settings.arguments as Map<String, dynamic>;
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(settings: settings, builder: (_) => HomePage());
            case '/family':
              final family = args['family'] as Family;
              return MaterialPageRoute(settings: settings, builder: (_) => FamilyPage(family));
            case '/person':
              final family = args['family'] as Family;
              final person = args['person'] as Person;
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
  static final families = [
    Family(
      name: 'Sells',
      people: [
        Person(name: 'Chris', age: 50),
        Person(name: 'John', age: 25),
        Person(name: 'Tom', age: 24),
      ],
    ),
    Family(
      name: 'Addams',
      people: [
        Person(name: 'Gomez', age: 55),
        Person(name: 'Morticia', age: 50),
        Person(name: 'Pugsley', age: 10),
        Person(name: 'Wednesday', age: 17),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(App.title)),
        body: ListView(
          children: families
              .map((f) => ListTile(
                  title: Text(f.name),
                  onTap: () => Navigator.pushNamed(context, '/family', arguments: {'family': f})))
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
                  onTap: () => Navigator.pushNamed(context, '/person',
                      arguments: {'family': family, 'person': p})))
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
  final String name;
  final int age;
  Person({this.name, this.age});
}

class Family {
  final String name;
  final List<Person> people;
  Family({this.name, this.people});
}
