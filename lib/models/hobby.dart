class Hobby{
  final int? id;
  late final String name;

  Hobby({required this.name, this.id});

  Hobby.fromMap(Map<String, dynamic> item):
        id=item["id"],
        name= item["name"];

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

  Hobby.fromDb(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'];
}