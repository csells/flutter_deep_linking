import 'package:flutter/foundation.dart';

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

class FamilyPerson {
  final Family family;
  final Person person;
  FamilyPerson(this.family, this.person);
}

class Repository {
  List<Family> _families;

  Future<void> _cacheFamilies() async {
    if (_families == null) {
      debugPrint('_cacheFamilies: _families == null');

      // simulate a network lookup...
      await Future.delayed(Duration(seconds: 1));

      _families = [
        Family(id: 'f1', name: 'Sells', people: [
          Person(id: 'p1', name: 'Chris', age: 50),
          Person(id: 'p2', name: 'John', age: 25),
          Person(id: 'p3', name: 'Tom', age: 24),
        ]),
        Family(id: 'f2', name: 'Addams', people: [
          Person(id: 'p1', name: 'Gomez', age: 55),
          Person(id: 'p2', name: 'Morticia', age: 50),
          Person(id: 'p3', name: 'Pugsley', age: 10),
          Person(id: 'p4', name: 'Wednesday', age: 17),
        ]),
      ];
    }
  }

  Future<Iterable<Family>> getFamilies() async {
    await _cacheFamilies();
    assert(_families != null);
    return _families;
  }

  Future<Family> getFamily(String fid) async {
    // simulate a network lookup...
    await Future.delayed(Duration(seconds: 1));
    return (await getFamilies())
        .singleWhere((f) => f.id == fid, orElse: () => throw 'unknown family $fid');
  }

  Future<FamilyPerson> getFamilyPerson(String fid, String pid) async {
    final family = await getFamily(fid);
    final person =
        family.people.singleWhere((p) => p.id == pid, orElse: () => throw 'unknown person $pid');
    return FamilyPerson(family, person);
  }
}
