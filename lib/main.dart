import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'data.dart';
import 'routers.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  static const title = 'Flutter Web Deep Linking Demo';
  static final families = Families.data;

  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: title,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomePage(),
        onGenerateRoute: AppRouter.onGenerateRoute,
      );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(App.title)),
        body: ListView(
          children: App.families
              .map((f) => ListTile(title: Text(f.name), onTap: () => FamilyPageRouter.navigate<void>(context, f)))
              .toList(),
        ),
      );
}

class FamilyPage extends StatelessWidget {
  final Future<Family> family;
  FamilyPage(String? fid, {Key? key})
      : family = _load(fid),
        super(key: key);

  static Future<Family> _load(String? fid) async {
    // simulate a network lookup...
    await Future<void>.delayed(const Duration(seconds: 1));

    final family = App.families.singleWhereOrNull((f) => f.id == fid);
    if (family == null) throw Exception('unknown family: $fid');

    return family;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: FutureBuilder<Family>(
            future: family,
            builder: (_, snapshot) => snapshot.hasData
                ? Text(snapshot.data!.name)
                : snapshot.hasError
                    ? const Text('Page Not Found')
                    : const Text('Loading...'),
          ),
        ),
        body: FutureBuilder<Family>(
          future: family,
          builder: (_, snapshot) => snapshot.hasData
              ? ListView(
                  children: snapshot.data!.people
                      .map((p) => ListTile(
                          title: Text(p.name),
                          onTap: () => PersonPageRouter.navigate<void>(context, snapshot.data!, p)))
                      .toList(),
                )
              : snapshot.hasError
                  ? Text(snapshot.error.toString())
                  : const CircularProgressIndicator(),
        ),
      );
}

class PersonPage extends StatelessWidget {
  final Future<FamilyPerson> familyPerson;
  PersonPage(String? fid, String? pid, {Key? key})
      : familyPerson = _load(fid, pid),
        super(key: key);

  static Future<FamilyPerson> _load(String? fid, String? pid) async {
    // simulate a network lookup...
    await Future<void>.delayed(const Duration(seconds: 1));

    final family = App.families.singleWhereOrNull((f) => f.id == fid);
    if (family == null) throw Exception('unknown family: $fid');

    final person = family.people.singleWhereOrNull((p) => p.id == pid);
    if (person == null) throw Exception('unknown person: $pid');

    return FamilyPerson(family, person);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: FutureBuilder<FamilyPerson>(
            future: familyPerson,
            builder: (_, snapshot) => snapshot.hasData
                ? Text(snapshot.data!.person.name)
                : snapshot.hasError
                    ? const Text('Page Not Found')
                    : const Text('Loading...'),
          ),
        ),
        body: Center(
          child: FutureBuilder<FamilyPerson>(
            future: familyPerson,
            builder: (_, snapshot) => snapshot.hasData
                ? Text(
                    '${snapshot.data!.person.name} ${snapshot.data!.family.name} is ${snapshot.data!.person.age} years old')
                : snapshot.hasError
                    ? Text(snapshot.error.toString())
                    : const CircularProgressIndicator(),
          ),
        ),
      );
}

class Four04Page extends StatelessWidget {
  final String message;
  const Four04Page(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Page Not Found')),
        body: Center(child: Text(message)),
      );
}
