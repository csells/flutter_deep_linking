import 'package:flutter/material.dart';
import 'data.dart';
import 'routers.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  static final title = 'Flutter Web Deep Linking Demo';
  static final families = Families.data;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: title,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: HomePage(),
        onGenerateRoute: Router.onGenerateRoute,
      );
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(App.title)),
        body: ListView(
          children: App.families
              .map((f) =>
                  ListTile(title: Text(f.name), onTap: () => FamilyPageRouter.navigate(context, f)))
              .toList(),
        ),
      );
}

class FamilyPage extends StatelessWidget {
  final Future<Family> family;
  FamilyPage(String fid) : family = _load(fid);

  static Future<Family> _load(String fid) async {
    // simulate a network lookup...
    await Future.delayed(Duration(seconds: 1));

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
                          onTap: () => PersonPageRouter.navigate(context, snapshot.data, p)))
                      .toList(),
                )
              : snapshot.hasError ? Text(snapshot.error) : CircularProgressIndicator(),
        ),
      );
}

class PersonPage extends StatelessWidget {
  final Future<FamilyPerson> familyPerson;
  PersonPage(String fid, String pid) : familyPerson = _load(fid, pid);

  static Future<FamilyPerson> _load(String fid, String pid) async {
    // simulate a network lookup...
    await Future.delayed(Duration(seconds: 1));

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
