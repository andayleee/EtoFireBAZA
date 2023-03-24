import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_firebase/login_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class RegPage extends StatefulWidget {
  const RegPage({Key? key}) : super(key: key);
  static const routeName = '/registration';
  @override
  _RegPageState createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _smscodeController = TextEditingController();
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String verificationId1 = "";
  int? resendToken1 = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40.0),
                const Text(
                  'Welcome!',
                  style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                const Text(
                  'Registration',
                  style: TextStyle(color: Colors.grey),
                ),
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
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 15.0),
                Center(
                  child: TextButton(
                    onPressed: () async {
                      try {
                        UserCredential userCredential =
                            await _auth.createUserWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                        await fireStore
                            .collection('user')
                            .doc(userCredential.user!.uid)
                            .set(
                              {'email': _emailController.text},
                            )
                            .then((value) => ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                                    content: Text("Пользователь добавлен"))))
                            .catchError((error) => ScaffoldMessenger.of(context)
                                .showSnackBar(
                                    SnackBar(content: Text("Фэйл: $error"))));
                        Navigator.pop(context);
                      } on FirebaseAuthException catch (e) {
                        print(e);
                      }
                    },
                    child: const Text('Registration!'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
