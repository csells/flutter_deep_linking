import 'package:flutter/material.dart';
import 'data.dart';
import 'routers.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  static final title = 'Flutter Web Deep Linking Demo';
  static final repository = Repository();

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: title,
        theme: ThemeData(primarySwatch: Colors.blue),
        onGenerateRoute: Router.onGenerateRoute,
      );
}

class HomePage extends StatelessWidget {
  final Future<Iterable<Family>> futureFamilies;
  HomePage() : futureFamilies = App.repository.getFamilies();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: FutureBuilder<Iterable<Family>>(
            future: futureFamilies,
            builder: (context, snapshot) => snapshot.hasError
                ? Text('Page Not Found')
                : snapshot.hasData ? Text('Families') : Text('Loading...'),
          ),
        ),
        body: FutureBuilder<Iterable<Family>>(
          future: futureFamilies,
          builder: (context, snapshot) => snapshot.hasError
              ? Center(child: Text(snapshot.error.toString()))
              : snapshot.hasData ? _build(context, snapshot.data) : CircularProgressIndicator(),
        ),
      );

  Widget _build(BuildContext context, Iterable<Family> families) => ListView(
      children: families
          .map(
            (f) => ListTile(
              title: Text(f.name),
              onTap: () => FamilyPageRouter.navigate(context, f),
            ),
          )
          .toList());
}

class FamilyPage extends StatelessWidget {
  final Future<Family> futureFamily;
  FamilyPage(String fid) : futureFamily = App.repository.getFamily(fid);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: FutureBuilder<Family>(
            future: futureFamily,
            builder: (context, snapshot) => snapshot.hasError
                ? Text('Page Not Found')
                : snapshot.hasData ? Text(snapshot.data.name) : Text('Loading...'),
          ),
        ),
        body: FutureBuilder<Family>(
          future: futureFamily,
          builder: (context, snapshot) => snapshot.hasError
              ? Center(child: Text(snapshot.error))
              : snapshot.hasData ? _build(context, snapshot.data) : CircularProgressIndicator(),
        ),
      );

  Widget _build(BuildContext context, Family family) => ListView(
        children: family.people
            .map(
              (p) => ListTile(
                title: Text(p.name),
                onTap: () => PersonPageRouter.navigate(context, family, p),
              ),
            )
            .toList(),
      );
}

class PersonPage extends StatelessWidget {
  final Future<FamilyPerson> futureFamilyPerson;
  PersonPage(String fid, String pid)
      : futureFamilyPerson = App.repository.getFamilyPerson(fid, pid);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: FutureBuilder<FamilyPerson>(
            future: futureFamilyPerson,
            builder: (context, snapshot) => snapshot.hasError
                ? Text('Page Not Found')
                : snapshot.hasData ? Text(snapshot.data.person.name) : Text('Loading...'),
          ),
        ),
        body: Center(
          child: FutureBuilder<FamilyPerson>(
            future: futureFamilyPerson,
            builder: (context, snapshot) => snapshot.hasError
                ? Text(snapshot.error)
                : snapshot.hasData
                    ? _build(context, snapshot.data.family, snapshot.data.person)
                    : CircularProgressIndicator(),
          ),
        ),
      );

  Widget _build(BuildContext context, Family family, Person person) =>
      Center(child: Text('${person.name} ${family.name} is ${person.age} years old'));
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
