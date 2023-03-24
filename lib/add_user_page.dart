import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({Key? key}) : super(key: key);
  static const routeName = '/adduserpage';
  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('user').snapshots();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
          'Add Users',
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
                        .add(
                          {'email': _emailController.text},
                        )
                        .then((value) => ScaffoldMessenger.of(context)
                            .showSnackBar(
                                SnackBar(content: Text("User Added"))))
                        .catchError((error) => ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                                content: Text("Failed to add user: $error"))));
                    Navigator.pop(context);
                  },
                  child: const Text('ADD!'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
