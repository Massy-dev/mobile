import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scomv1/codeRepete/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;

class CreateProfil extends StatefulWidget {
  //const CreateProfil({ Key? key }) : super(key: key);
  final String userId;

  CreateProfil({required this.userId});

  @override
  State<CreateProfil> createState() => _CreateProfilState();
}

class _CreateProfilState extends State<CreateProfil> {
  final _formKey = GlobalKey<FormState>();

  String id = "";
  String nom = "";
  String prenom = "";
  String email = "";
  String photo = "";
  String? imageUrl;

  CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('Utilisateurs');

  Future getImage() async {
    final _storage = FirebaseStorage.instance;

    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    var file = File(image!.path);

    if (image != null) {
      //User? user = FirebaseAuth.instance.currentUser;
      var snapshot = await _storage
          .ref()
          .child('escomImage/imageName-' + widget.userId)
          .putFile(file);

      var downloadUrl = await snapshot.ref.getDownloadURL();

      users.doc(widget.userId).update({"photo": downloadUrl});

      setState(() {
        imageUrl = downloadUrl;
        //photo = downloadUrl;

        User? user = FirebaseAuth.instance.currentUser;
      });
    } else {
      print("'pas d'image");
    }
  }

  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('Utilisateurs')
        .doc(widget.userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var names = documentSnapshot["nom"];
        setState(() {
          nom = documentSnapshot["nom"];
          prenom = documentSnapshot["prenom"];
          email = documentSnapshot["email"];
          imageUrl = documentSnapshot["photo"];
        });
        print('Document data: ${photo}');
        //Set the relevant data to variables as needed
      } else {
        print('Document does not exist on the database');
      }
    });
  }
  //final collection = FirebaseFirestore.instance.collection('Utilisateur');

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xff476cfb),
                child: ClipOval(
                  child: SizedBox(
                    width: 100.0,
                    height: 100.0,
                    // ignore: unnecessary_null_comparison
                    child: (imageUrl != null)
                        ? Image.network(imageUrl!)
                        : Image.network(
                            "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
                            fit: BoxFit.fill,
                          ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: IconButton(
                icon: Icon(
                  FontAwesomeIcons.camera,
                  size: 30.0,
                ),
                onPressed: () {
                  getImage();
                },
              ),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              decoration: textInputDecorationProfil.copyWith(hintText: nom),
              validator: (val) => val!.isEmpty ? 'Champ obligatoire' : null,
              onChanged: (val) {
                setState(() => nom = val);
              },
            ),
            SizedBox(height: 10.0),
            TextFormField(
              decoration: textInputDecorationProfil.copyWith(hintText: prenom),
              validator: (val) => val!.isEmpty ? 'Champ obligatoire' : null,
              onChanged: (val) {
                setState(() => prenom = val);
              },
            ),
            SizedBox(height: 10.0),
            TextFormField(
              decoration: textInputDecorationProfil.copyWith(hintText: email),
              validator: (val) => val!.isEmpty ? 'Champ obligatoir' : null,
              onChanged: (val) {
                setState(() => email = val);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    var users = FirebaseFirestore.instance
                        .collection('Utilisateurs')
                        .doc(widget.userId);
                    users.set({
                      "nom": nom,
                      "prenom": prenom,
                      "email": email,
                      "id": widget.userId,
                      "photo": imageUrl,
                    }).then((_) {
                      print("succes");
                    }) .catchError(
                              (error) => print(widget.userId));
;

                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Envoie en cour')),
                    );
                  }
                },
                child: const Text('Enregistrer'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
