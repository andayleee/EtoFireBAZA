// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ImagesPage extends StatefulWidget {
  const ImagesPage({Key? key}) : super(key: key);
  static const routeName = '/imagespage';
  @override
  _ImagesPageState createState() => _ImagesPageState();
}

class _ImagesPageState extends State<ImagesPage> {
  Future<void> _incrementCounter() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      dialogTitle: 'Выбор файла',
    );

    if (result != null) {
      final size = result.files.first.size;
      final file = File(result.files.single.path!);
      final fileExtensions = result.files.first.extension!;
      final auth = FirebaseAuth.instance;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "размер:$size file:${file.path} fileExtensions:${fileExtensions}",
        ),
      ));
      String name = getRandomString(5);
      FirebaseStorage.instance.ref().child(name).putFile(file,
          SettableMetadata(customMetadata: {"User": auth.currentUser!.uid}));

      final FirebaseFirestore fireStore = FirebaseFirestore.instance;

      await fireStore
          .collection('images')
          .doc(name)
          .set(
            {
              'size': size,
              'path': file.toString(),
              'name': name,
            },
          )
          .then((value) => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("images info Added"))))
          .catchError((error) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Failed to add images info: $error"))));
    } else {}
  }

  String link = '';
  List<ModelTest> fullpath = [];

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<void> initImage() async {
    fullpath.clear();
    final storageReference = FirebaseStorage.instance.ref().list();
    final list = await storageReference;
    final auth = FirebaseAuth.instance;

    list.items.forEach((element) async {
      final meta = await element.getMetadata();
      final customValue = meta.customMetadata!['User'];
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${customValue}")));
      if (customValue == auth.currentUser!.uid) {
        final url = await element.getDownloadURL();
        Uint8List? size = await element.getData();
        fullpath.add(ModelTest(url, element.name, size?.lengthInBytes));
      }

      setState(() {});
    });
  }

  @override
  void initState() {
    initImage().then((value) {
      setState(() {});
    });
    super.initState();
  }

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
            'Images',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh_outlined),
              onPressed: () async {
                await initImage();
              },
            ),
            const SizedBox(width: 15.0),
            IconButton(
              icon: Icon(Icons.add_a_photo_outlined),
              onPressed: () async {
                await _incrementCounter();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 15.0),
            Expanded(
              flex: 2,
              child: ListView.builder(
                  itemCount: fullpath.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: InkWell(
                        onLongPress: () async {
                          final FirebaseFirestore fireStore =
                              FirebaseFirestore.instance;
                          await fireStore
                              .collection('images')
                              .doc(fullpath[index].name!)
                              .delete()
                              .then((value) => ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      content: Text("Image info Delete"))))
                              .catchError((error) => ScaffoldMessenger.of(
                                      context)
                                  .showSnackBar(SnackBar(
                                      content: Text(
                                          "Cant delete image info: $error"))));
                          link = '';
                          await FirebaseStorage.instance
                              .ref("/" + fullpath[index].name!)
                              .delete();
                          await initImage();
                          setState(() {});
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "${fullpath[index].name!}",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            Image.network(
                              fullpath[index].url!,
                              fit: BoxFit.fitWidth,
                            ),
                            Text(
                              "Size: ${fullpath[index].size!}",
                              style: TextStyle(fontSize: 15.0),
                            ),
                            Text(
                              "Url: ${fullpath[index].url!}",
                              style: TextStyle(fontSize: 15.0),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ));
  }
}

class ModelTest {
  String? url;
  String? name;
  int? size;

  ModelTest(this.url, this.name, this.size);
}
