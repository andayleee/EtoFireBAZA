import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditUserPage extends StatefulWidget {
  const EditUserPage({Key? key}) : super(key: key);
  static const routeName = '/edituserpage';
  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('user').snapshots();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    _emailController.text = arguments['email'].toString();
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Edit Users',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Email or Phone number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15.0),
              Center(
                child: TextButton(
                  onPressed: () async {
                    final FirebaseFirestore fireStore =
                        FirebaseFirestore.instance;
                    final auth = FirebaseAuth.instance;
                    await fireStore
                        .collection('user')
                        .doc(arguments['id'].toString())
                        .set(
                          {'email': _emailController.text},
                        )
                        .then((value) => ScaffoldMessenger.of(context)
                            .showSnackBar(
                                SnackBar(content: Text("User Update"))))
                        .catchError((error) => ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                                content:
                                    Text("Failed to update user: $error"))));
                    Navigator.pop(context);
                  },
                  child: const Text('EDIT!'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
