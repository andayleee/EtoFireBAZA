import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_firebase/main_page.dart';
import 'package:flutter_application_firebase/reg_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const routeName = '/login';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _smscodeController = TextEditingController();
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
                  'Login',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 40.0),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                      const SizedBox(height: 30.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: _emailController.text,
                                      password: _passwordController.text)
                                  .then((value) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    "${value.user?.email}, ${value.user?.uid}",
                                  ),
                                ));
                                Navigator.pushNamed(
                                    context, MainPage.routeName);
                              });
                            }
                          },
                          child: const Text('Login'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15.0),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RegPage.routeName);
                    },
                    child: const Text('Registration'),
                  ),
                ),
                // const SizedBox(height: 15.0),
                // Center(
                //   child: TextButton(
                //     onPressed: () {
                //       FirebaseAuth.instance.signInAnonymously().then((value) {
                //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //           content: Text(
                //             "${value.user?.email}, ${value.user?.uid}",
                //           ),
                //         ));
                //       });
                //     },
                //     child: const Text('Anonimous'),
                //   ),
                // ),
                // const SizedBox(height: 15.0),
                // Center(
                //   child: TextButton(
                //     onPressed: () {
                //       try {
                //         FirebaseAuth.instance
                //             .sendSignInLinkToEmail(
                //                 email: _emailController.text,
                //                 actionCodeSettings: ActionCodeSettings(
                //                     url:
                //                         "https://flutterapplicationfirebase.page.link/RtQw",
                //                     handleCodeInApp: true,
                //                     iOSBundleId:
                //                         'com.example.flutterApplicationFirebase',
                //                     androidPackageName:
                //                         'com.example.flutter_application_firebase',
                //                     // installIfNotAvailable
                //                     androidInstallApp: true,
                //                     // minimumVersion
                //                     androidMinimumVersion: '12'))
                //             .then((value) {
                //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //             content: Text(
                //               "${FirebaseAuth.instance.currentUser!.emailVerified}, ${FirebaseAuth.instance.currentUser!.email}",
                //             ),
                //           ));
                //         });
                //       } on FirebaseAuthException catch (e) {
                //         print(e);
                //       }
                //     },
                //     child: const Text('Email link'),
                //   ),
                // ),
                const SizedBox(height: 15.0),
                Center(
                  child: TextButton(
                    onPressed: () async {
                      try {
                        signInWithGoogle().then((value) => {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  "${FirebaseAuth.instance.currentUser!.uid}, ${FirebaseAuth.instance.currentUser!.email}",
                                ),
                              )),
                              Navigator.pushNamed(context, MainPage.routeName)
                            });
                        UserCredential userCredential =
                            await signInWithGoogle();
                        User user = userCredential.user!;
                      } on FirebaseAuthException catch (e) {
                        print(e);
                      }
                    },
                    child: const Text('Google'),
                  ),
                ),
                // const SizedBox(height: 15.0),
                // Center(
                //   child: TextButton(
                //     onPressed: () async {
                //       try {
                //         await FirebaseAuth.instance.verifyPhoneNumber(
                //           phoneNumber: _emailController.text,
                //           codeSent:
                //               (String verificationId, int? resendToken) async {
                //             verificationId1 = verificationId;
                //             resendToken1 = resendToken;
                //             var showSnackBar = ScaffoldMessenger.of(context)
                //                 .showSnackBar(const SnackBar(
                //               content: Text(
                //                 "SMS отправленo",
                //               ),
                //             ));
                //           },
                //           codeAutoRetrievalTimeout: (String verificationId) {},
                //           verificationCompleted:
                //               (PhoneAuthCredential phoneAuthCredential) {},
                //           verificationFailed: (FirebaseAuthException error) {},
                //         );
                //       } on FirebaseAuthException catch (e) {
                //         print(e);
                //       }
                //     },
                //     child: const Text('SMS send'),
                //   ),
                // ),
                // const SizedBox(height: 20.0),
                // TextFormField(
                //   controller: _smscodeController,
                //   decoration: InputDecoration(
                //     filled: true,
                //     fillColor: Colors.white,
                //     labelText: 'Smscode',
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(10.0),
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 15.0),
                // Center(
                //   child: TextButton(
                //     onPressed: () async {
                //       try {
                //         // Update the UI - wait for the user to enter the SMS code
                //         String smsCode = _smscodeController.text;

                //         // Create a PhoneAuthCredential with the code
                //         PhoneAuthCredential credentiall =
                //             PhoneAuthProvider.credential(
                //                 verificationId: verificationId1,
                //                 smsCode: smsCode);

                //         // Sign the user in (or link) with the credential
                //         await FirebaseAuth.instance
                //             .signInWithCredential(credentiall);
                //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //           content: Text(
                //             "${FirebaseAuth.instance.currentUser!.uid}, ${FirebaseAuth.instance.currentUser!.phoneNumber}",
                //           ),
                //         ));
                //       } on FirebaseAuthException catch (e) {
                //         print(e);
                //       }
                //     },
                //     child: const Text('SMS Login'),
                //   ),
                // ),
                // const SizedBox(height: 15.0),
                // Center(
                //   child: TextButton(
                //     onPressed: () async {
                //       try {
                //         final appleProvider = AppleAuthProvider();
                //         await FirebaseAuth.instance
                //             .signInWithProvider(appleProvider);
                //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //           content: Text(
                //             "${FirebaseAuth.instance.currentUser!.uid}, ${FirebaseAuth.instance.currentUser!.phoneNumber}",
                //           ),
                //         ));
                //       } on FirebaseAuthException catch (e) {
                //         print(e);
                //       }
                //     },
                //     child: const Text('Apple'),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    return await _auth.signInWithCredential(credential);
  }
}
