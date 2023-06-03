import 'package:app_personas/models/hobby.dart';
import 'package:app_personas/models/person_hobby.dart';
import 'package:app_personas/services/person_hobby_service.dart';
import 'package:flutter/material.dart';
import 'package:app_personas/models/person.dart';
import 'package:app_personas/services/sqlite_service.dart';
import 'package:app_personas/services/hobby_service.dart';
import 'package:app_personas/screens/shared/bottom_container/bottom_container.dart';
import 'package:app_personas/screens/add_edit/add_hobby.dart';

class AddEditPerson extends StatefulWidget {
  const AddEditPerson({ Key? key }) : super(key: key);

  @override
  _AddEditPersonState createState() => _AddEditPersonState();
}

class _AddEditPersonState extends State<AddEditPerson> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late SqliteService query;
  late HobbyService queryHobby = HobbyService();
  late PersonHobbyService queryPersonHobby = PersonHobbyService();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  late Map args = ModalRoute.of(context)?.settings.arguments as Map;
  late Person? personToUpdate = args['person'];
  late List<Hobby> hobbiesPersonList = [];
  late List<Hobby> hobbiesToAdd = [];
  late List<Hobby> hobbiesToDeleteIds = [];
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    query = SqliteService();
    query.initDb().whenComplete(() {
      setState(() async {
        if(personToUpdate?.id != null) {
          nameController.text = personToUpdate!.name;
          ageController.text = personToUpdate!.age.toString();
          isEditing = true;
          setInitHobbies();
        }
      });
    });
  }

  Future<void> setInitHobbies() async {
    var hobbies = await getPersonHobbies(personToUpdate!.id!);
    setState(() {
      hobbiesPersonList = List.from(hobbiesPersonList)..addAll(hobbies);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: const Color.fromRGBO(247, 250, 252, 1.0),
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(94, 114, 228, 1.0),
          elevation: 0.0,
          title: const Text('Add or edit a person'),
        ),
        body: Column(
          children:[
            Expanded(
                child:Container(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            hintText: 'Name',
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the name';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: ageController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Age',
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the age';
                            }
                            return null;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Column(
                            children: [
                              ElevatedButton(
                                onPressed: () async{
                                  if (formKey.currentState!.validate()) {
                                    final toastMessage = isEditing ? 'Person updated' : 'Person created';
                                    await addOrEditPerson();
                                    var snackBar = SnackBar(content: Text(toastMessage));
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      Navigator.pop(context, 'newUser');
                                    }
                                  }
                                },
                                child: Text(isEditing ? 'Edit' : 'Save'),
                              ),
                              addHobbyButton(),
                              hobbiesList()
                            ],
                          )
                        ),
                      ],
                    ),
                  )
                )
            ),
            BottomContainer(),
          ]
        ),
    );
  }

  Future<void> addOrEditPerson() async {
    String name = nameController.text;
    String age = ageController.text;

    if (isEditing) {
      final Person updatedPerson = Person(id: personToUpdate!.id,name: name,age: int.parse(age));
      await updatePerson(updatedPerson!);
    } else {
      Person personToCreate = Person(name: name, age: int.parse(age));
      await addPerson(personToCreate);
    }
    resetData();
    setState(() {});
  }

  Future<int> addPerson(Person person) async {
    List hobbiesIds = await addHobbiesToDB(hobbiesToAdd);
    int personId = await query.createPerson(person);
    for( var i = 0 ; i < hobbiesIds.length; i++ ) {
      PersonHobby personHobby = PersonHobby(personId: personId, hobbyId: hobbiesIds[i]);
      await queryPersonHobby.createPersonHobby(personHobby);
    }
    return personId;
  }

  Future<int> updatePerson(Person person) async {
    List hobbiesIds = await addHobbiesToDB(hobbiesToAdd);
    int personId = await query.updatePerson(person);
    for( var i = 0 ; i < hobbiesIds.length; i++ ) {
      PersonHobby personHobby = PersonHobby(personId: personId, hobbyId: hobbiesIds[i]);
      await queryPersonHobby.createPersonHobby(personHobby);
    }
    return personId;
  }

  Future<List> addHobbiesToDB(List<Hobby> hobbies) async {
    List hobbiesIds = [];
    for( var i = 0 ; i < hobbies.length; i++ ) {
      int hobbyId = await queryHobby.createHobby(hobbies[i]);
      hobbiesIds.add(hobbyId);
    }
    return hobbiesIds;
  }

  Widget addHobbyButton() {
    return  ElevatedButton(
        onPressed: () async {
          String hobbyToAdd = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return addHobbyAlert();
              }
          );
          addHobby(hobbyToAdd);
        },
        child: const Text('Add Hobby')
    );
  }

  void resetData() {
    nameController.clear();
    ageController.clear();
    isEditing = false;
  }

  Widget addHobbyAlert() {
    return AlertDialog(
        title: const Text("Add hobby"),
        content: Stack(
            clipBehavior: Clip.none,
            children: const <Widget>[
              AddHobby()
            ]
        )
    );
  }

  Widget hobbiesList() {
    return(
      ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(10.0),
        itemCount: hobbiesPersonList.length,
        itemBuilder: (context, i) {
          return _buildHobbyRow(hobbiesPersonList[i]?.id,hobbiesPersonList[i].name);
        },
      )
    );
  }

  Widget _buildHobbyRow(int? id,String hobby) {
    return Dismissible(
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: const Icon(Icons.delete_forever),
        ),
        key: UniqueKey(),
        onDismissed: (DismissDirection direction) {
          deleteHobby(id);
        },
        child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Column(
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
                                child: Text(
                                  hobby,
                                  style: const TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ]
                        )
                      ]
                  )
                ]
            )
        )
    );
  }

  void deleteHobby(int? id) {
    setState(() {
      if(id != null){
        if(isEditing){
          //hobbiesToDeleteIds = List.from(hobbiesToDeleteIds)..add(id);
        }
      }
      //hobbiesToAdd = List.from(hobbiesToAdd)..removeAt(key);
    });
  }

  void addHobby(String hobby){
    setState(() {
      Hobby hobbyToAdd = Hobby(name: hobby);
      hobbiesToAdd = List.from(hobbiesToAdd)..add(hobbyToAdd);
      hobbiesPersonList = List.from(hobbiesPersonList)..add(hobbyToAdd);
    });
  }

  Future<List<Hobby>> getPersonHobbies(int id) async {
    List<Hobby> hobbies = [];
    List<PersonHobby> personHobbies = await queryPersonHobby.getAllHobbiesFromPerson(id);
    for( var i = 0 ; i < personHobbies.length; i++ ) {
      Hobby? hobby = await queryHobby.getHobby(personHobbies[i].hobbyId);
      if(hobby != null) {
        hobbies.add(hobby);
      }
    }
    return hobbies;
  }
}

