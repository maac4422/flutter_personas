import 'package:app_personas/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:app_personas/services/sqlite_service.dart';

class HobbiesStatistics extends StatefulWidget {
  const HobbiesStatistics({ Key? key }) : super(key: key);

  @override
  _HobbiesStatisticsState createState() => _HobbiesStatisticsState();
}

class _HobbiesStatisticsState extends State<HobbiesStatistics> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late SqliteService query;
  final userController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    query = SqliteService();
    query.initDb().whenComplete(() async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 250, 252, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(94, 114, 228, 1.0),
        elevation: 0.0,
        title: const Text('Hobbies '),
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
                            controller: userController,
                            decoration: const InputDecoration(
                              hintText: 'Username',
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the username';
                              }
                              if (value != 'admin') {
                                return 'The username is incorrect';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: passwordController,
                            decoration: const InputDecoration(
                              hintText: 'Password',
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the password';
                              }
                              if (value != 'password') {
                                return 'The password is incorrect';
                              }
                              return null;
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                              onPressed: () async{
                                if (formKey.currentState!.validate()) {
                                  if (context.mounted) {
                                    Navigator.pushAndRemoveUntil( context, MaterialPageRoute(builder: (context) => const Home()), (Route<dynamic> route) => false);
                                  }
                                }
                              },
                              child: const Text('Login'),
                            ),
                          ),
                        ],
                      ),
                    )
                )
            )
          ]
      ),
    );
  }
}

