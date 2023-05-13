class Person{
  final int? id;
  late final String name;
  late final int age;

  Person({required this.name, required this.age, this.id});

  Person.fromMap(Map<String, dynamic> item):
        id=item["id"],
        name= item["name"],
        age= item["age"];

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['age'] = age;
    return map;
  }

  Person.fromDb(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        age = map['age'];
}