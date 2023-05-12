class Person{
  final int? id;
  final String name;
  final int age;

  Person({required this.id, required this.name, required this.age});

  Person.fromMap(Map<String, dynamic> item):
        id=item["id"], name= item["name"] ,age= item["age"];

  Map<String, Object> toMap(){
    return {'id':id,'name': name, 'age': age};
  }

  Person.fromDb(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        age = map['age'];
}