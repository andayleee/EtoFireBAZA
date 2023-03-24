import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_firebase/add_user_page.dart';
import 'package:flutter_application_firebase/edit_user_page.dart';
import 'package:flutter_application_firebase/images_page.dart';
import 'package:flutter_application_firebase/login_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  static const routeName = '/mainpage';
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('user').snapshots();

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
          'Users',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_outlined),
            onPressed: () {
              Navigator.pushNamed(context, ImagesPage.routeName);
            },
          ),
          IconButton(
            icon: Icon(Icons.add_circle_outline_rounded),
            onPressed: () {
              Navigator.pushNamed(context, AddUserPage.routeName);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 15.0),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _usersStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Oops!!!');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("WAIT");
                }
                return ListView(
                  padding: const EdgeInsets.all(8),
                  children: snapshot.data!.docs
                      .map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  data['email'],
                                  style: TextStyle(fontSize: 18.0),
                                )),
                            IconButton(
                              onPressed: () async {
                                final FirebaseFirestore fireStore =
                                    FirebaseFirestore.instance;
                                await fireStore
                                    .collection('user')
                                    .doc(document.id)
                                    .delete()
                                    .then((value) =>
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text("User Delete"))))
                                    .catchError((error) => ScaffoldMessenger.of(
                                            context)
                                        .showSnackBar(SnackBar(
                                            content: Text(
                                                "Cant delete user: $error"))));
                              },
                              icon: Icon(Icons.delete_outline),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  EditUserPage.routeName,
                                  arguments: {
                                    'id': document.id,
                                    'email': data['email'],
                                  },
                                );
                              },
                              icon: Icon(Icons.mode_edit_outline_outlined),
                            ),
                          ],
                        );
                      })
                      .toList()
                      .cast(),
                );
              },
            ),
          ),
          const SizedBox(height: 15.0),
        ],
      ),
    );
  }
}
