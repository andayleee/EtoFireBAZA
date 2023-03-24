import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_firebase/add_user_page.dart';
import 'edit_user_page.dart';
import 'firebase_options.dart';
import 'images_page.dart';
import 'login_page.dart';
import 'package:flutter_application_firebase/login_page.dart';
import 'package:flutter_application_firebase/reg_page.dart';
import 'package:flutter_application_firebase/main_page.dart';
import 'package:flutter_application_firebase/add_user_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        LoginPage.routeName: (context) => const LoginPage(),
        RegPage.routeName: (context) => const RegPage(),
        MainPage.routeName: (context) => const MainPage(),
        AddUserPage.routeName: (context) => const AddUserPage(),
        EditUserPage.routeName: (context) => const EditUserPage(),
        ImagesPage.routeName: (context) => const ImagesPage(),
      },
      initialRoute: LoginPage.routeName,
      title: 'Flutter Login Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
