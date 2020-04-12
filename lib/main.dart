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
              return MaterialPageRoute(settings: settings, builder: (_) => FamilyPage(args['fid']));

            case '/person':
              return MaterialPageRoute(
                  settings: settings, builder: (_) => PersonPage(args['fid'], args['pid']));

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
  final Future<Family> family;
  FamilyPage(String fid) : family = _load(fid);

  static Future<Family> _load(String fid) async {
    // simulate a network lookup...
    await Future.delayed(Duration(seconds: 3));

    final family = App.families.singleWhere((f) => f.id == fid, orElse: () => null);
    if (family == null) throw 'unknown family: $fid';

    return family;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: FutureBuilder<Family>(
            future: family,
            builder: (_, snapshot) => snapshot.hasData
                ? Text(snapshot.data.name)
                : snapshot.hasError ? Text('Page Not Found') : Text('Loading...'),
          ),
        ),
        body: FutureBuilder<Family>(
          future: family,
          builder: (_, snapshot) => snapshot.hasData
              ? ListView(
                  children: snapshot.data.people
                      .map((p) => ListTile(
                          title: Text(p.name),
                          onTap: () => Navigator.pushNamed(
                              context, '/person?fid=${snapshot.data.id}&pid=${p.id}')))
                      .toList(),
                )
              : snapshot.hasError ? Text(snapshot.error) : CircularProgressIndicator(),
        ),
      );
}

class FamilyPerson {
  final Family family;
  final Person person;
  FamilyPerson(this.family, this.person);
}

class PersonPage extends StatelessWidget {
  final Future<FamilyPerson> familyPerson;
  PersonPage(String fid, String pid) : familyPerson = _load(fid, pid);

  static Future<FamilyPerson> _load(String fid, String pid) async {
    // simulate a network lookup...
    await Future.delayed(Duration(seconds: 3));

    final family = App.families.singleWhere((f) => f.id == fid, orElse: () => null);
    if (family == null) throw 'unknown family: $fid';

    final person = family.people.singleWhere((p) => p.id == pid, orElse: () => null);
    if (person == null) throw 'unknown person: $pid';

    return FamilyPerson(family, person);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: FutureBuilder<FamilyPerson>(
            future: familyPerson,
            builder: (_, snapshot) => snapshot.hasData
                ? Text(snapshot.data.person.name)
                : snapshot.hasError ? Text('Page Not Found') : Text('Loading...'),
          ),
        ),
        body: Center(
          child: FutureBuilder<FamilyPerson>(
            future: familyPerson,
            builder: (_, snapshot) => snapshot.hasData
                ? Text(
                    '${snapshot.data.person.name} ${snapshot.data.family.name} is ${snapshot.data.person.age} years old')
                : snapshot.hasError ? Text(snapshot.error) : CircularProgressIndicator(),
          ),
        ),
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
