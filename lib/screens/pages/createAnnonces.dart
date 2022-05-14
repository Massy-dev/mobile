import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'package:scomv1/codeRepete/constants.dart';

class CreateAnnonces extends StatefulWidget {
  const CreateAnnonces({Key? key}) : super(key: key);

  @override
  State<CreateAnnonces> createState() => _AnnoncesState();
}

class _AnnoncesState extends State<CreateAnnonces> {
  bool uploading = false;
  double val = 0;

  var annonceId;
  //late CollectionReference imgRef;
  late firebase_storage.Reference ref;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  List<String> photo = [];

  List<File> _image = [];
  String libelle = "";
  String description = "";
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Faite une annonce"),
          /*actions: [
            FlatButton(
              onPressed: () {
                  setState(() {
                    uploading = true;
                  });
                  uploadFile().whenComplete(() => Navigator.push(context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Annonces()),
                                      ));
                },
                child: Text(
                  'upload',
                  style: TextStyle(color: Colors.white),
                )
            ),
          ],*/
        ),
        body: Center(
            child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(4),
                child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: _image.length + 1,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (context, index) {
                      return index == 0
                          ? Container(
                                height: 18.0,
                                width: 18.0,
                              child: ElevatedButton.icon(
                                  //icon: Icon(Icons.add),
                                  onPressed: () =>
                                      !uploading ? chooseImage() : null,
                                      icon: const Icon(
                                        Icons.add,
                                        color: Colors.blue,
                                        size: 30,
                                        
                                        
                                        
                                      ),
                         
                                          label: Text(""),

                                          style: ElevatedButton.styleFrom(
                                            side: BorderSide(width: 1.0, color: Colors.blue,),
                                            primary: Colors.white,
                                            
                                            fixedSize: const Size(10, 10),
                                            shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                            
                                            ),
                                                                                      
                                          ),  
                                      
                                      ),
                                      
                                      


                            )
                          : Container(
                              margin: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: FileImage(_image[index - 1]),
                                      fit: BoxFit.cover)),
                            );
                    }),
              ),
              uploading
                  ? Center(
                      child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          child: Text(
                            'uploading...',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CircularProgressIndicator(
                          value: val,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.green),
                        )
                      ],
                    ))
                  : Container(),
              SizedBox(height: 10.0),
              SizedBox(
                width: 300,
                child: TextFormField(
                    decoration:
                        textInputDecorationDemande.copyWith(hintText: 'Libelle'),
                    validator: (val) => val!.length < 6 ? 'Libelle ' : null,
                    onChanged: (val) {
                      setState(() => libelle = val);
                    }),
              ),
              SizedBox(height: 10.0),
              SizedBox(
                width: 300,
                child: TextFormField(
                      
                 
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  minLines: 10,
                  maxLines: null,
                  decoration:
                      textInputDecorationDemande.copyWith(hintText: 'Description'),
                  validator: (val) => val!.isEmpty ? 'Description' : null,
                  onChanged: (val) {
                    setState(() => description = val);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),

                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      uploading = true;
                    });
                    if (1==1) {
                      var annonce =
                          FirebaseFirestore.instance.collection('Anonces');
                      annonce
                          .add({
                            "libelle": libelle,
                            "description": description,
                            "annonceurId": user!.uid,
                            // ignore: avoid_print
                          })
                          .then((value) => (setState(() {
                                annonceId = value.id;
                                uploadFile(value.id).whenComplete(() {
                                  if (kDebugMode) {
                                    print("bingooooooo");
                                  }
                                });
                              })))
                          .catchError(
                              (error) => print("Failed to add user: $error"));

                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Envoie en cour')),
                      );
                    } else {
                      print("formulaire invale------------$_formKey");
                    }

                    // Validate returns true if the form is valid, or false otherwise.
                  },
                   icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                            
                            
                          ),
                         
                        label: Text("Poster",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),),

                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          fixedSize: const Size(150, 50),
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          ),
                                                                    
                        ),
                ),
              )
            ],
          ),
        )));
  }

  chooseImage() async {
    // ignore: deprecated_member_use
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile!.path));
    });
    if (pickedFile!.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    // ignore: deprecated_member_use
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file!.path));
      });
    } else {
      print(response.file);
    }
  }

  Future uploadFile(String id) async {
    int i = 1;

    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('imagesAnnonces/${Path.basename(img.path)}');

      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          if (kDebugMode) {
            print("lkjfndll mon id annonce" + annonceId);
          }
          var imgRef = FirebaseFirestore.instance.collection('Anonces').doc(id);

          imgRef
              .update({
                "photos": FieldValue.arrayUnion([value])
              })
              .then((value) =>
                  // ignore: avoid_print
                  print("---------------------juste"))
              .catchError(

                  // ignore: avoid_print
                  (error) => print("Failed to add user: $error "));

          i++;
        });
      });
    }
  }

  /*sendData() {
    if (_formKey.currentState!.validate()) {
      var users = FirebaseFirestore.instance.collection('Anonces').add({
        "libelle": libelle,
        "description": description,
        "photo": _image,
        "annonceurId": user!.uid,
      }).then((_) {
        print("succes");
      });

      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Envoie en cour')),
      );
    }
  }
*/
  /*@override
  void initState() {
    super.initState();
    //imgRef = FirebaseFirestore.instance.collection('image');
    //imgRef = FirebaseFirestore.instance.collection('Utilisateur').doc(user!.uid) as CollectionReference<Object?>;
    var imgRef = FirebaseFirestore.instance
        .collection('Anonces')
        .doc(annonceId);
        
  }*/
}
