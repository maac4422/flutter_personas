class PersonHobby{
  final int? id;
  late final int personId;
  late final int hobbyId;

  PersonHobby({required this.personId,required this.hobbyId, this.id});

  PersonHobby.fromMap(Map<String, dynamic> item):
        id=item["id"],
        personId= item["personId"],
        hobbyId= item["hobbyId"];

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{};
    map['id'] = id;
    map['personId'] = personId;
    map['hobbyId'] = hobbyId;
    return map;
  }

  PersonHobby.fromDb(Map<String, dynamic> map)
      : id = map['id'],
        personId = map['personId'],
        hobbyId = map['hobbyId'];
}