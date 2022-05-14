/* import 'dart:io';

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

  CreateProfil({required this.userId, void Function(int index) changePage});

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
      //Future<void> rubriques = FirebaseFirestore.instance
      //.collection('Utilisateurs')
      // .doc(widget.userId)
      //.update({"photo": downloadUrl});

      setState(() {
        imageUrl = downloadUrl;
        photo = downloadUrl;
        User? user = FirebaseAuth.instance.currentUser;
      });
    } else {
      print("'pas d'image");
    }

    @override
    Future<Widget> build(BuildContext context) async {
      var collection = FirebaseFirestore.instance.collection('Utilisateur');
      var docSnapshot = await collection.doc(widget.userId).get();
      Map<String, dynamic>? data = docSnapshot.data();

      return Scaffold(
        appBar: AppBar(
          title: const Text('Second Route'),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor: Color(0xff476cfb),
                    child: ClipOval(
                      child: SizedBox(
                        width: 180.0,
                        height: 180.0,
                        child: (imageUrl != null)
                            ? Image.network(imageUrl!)
                            : Image.network(
                                "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
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
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Nom'),
                  validator: (val) => val!.isEmpty ? data!['nom'] : null,
                  onChanged: (val) {
                    setState(() => nom = val);
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Prénom'),
                  validator: (val) => val!.isEmpty ? 'Champ obligatoire' : null,
                  onChanged: (val) {
                    setState(() => prenom = val);
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
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
                            .collection('Utilisateur')
                            .doc(widget.userId);
                        users.update({
                          "nom": nom,
                          "prenom": prenom,
                          "email": email,
                          "id": widget.userId,
                          "photo": photo,
                        }).then((_) {
                          print("succes");
                        });

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
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

/*

                                height: 30,
                                width: 295,
                                child: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('Anonces')
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (!snapshot.hasData) {
                                        return Center(
                                          child: Text( "Info wird geladen        "),
                                        );
                                      }

                                      return ListView(
                                        children:
                                            snapshot.data!.docs.map((document) {
                                          return Container(
                                            child: Center(
                                                child: Text(document['photo1'])),
                                          );
                                        }).toList(),
                                      );
                                    })


                                     children:[

                                  data["photos"].forEach((var img) => 
                                  ListTile(
                                      title: Text('doc.id: ${data['description']}'),
                                      subtitle: Text('category:     ${data['libelle']}'),
                                    ),
                                  ),
                                  // ignore: unused_local_variable
                                  for (var item in data["photos"]) {
                                    Text('category:     ${data['libelle']}'),
                                    i++;
                                  };
                                ],


                                -*****************register*******************
                                 TextField(
                                    controller: phoneController,
                                    decoration: InputDecoration(labelText: "Téléphone"),
                                    keyboardType: TextInputType.phone,
                                  ),


                                  
                                 

                                  Visibility(
                                    child: TextField(
                                      controller: otpController,
                                      decoration: InputDecoration(
                                        labelText: "saisir le code",
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                    visible: otpVisibility,
                                  ),

                                  SizedBox(
                                    height: 10,
                                  ),

                                  /*TextField(),
                                  SizedBox(height: 10,),*/

                                  ElevatedButton(
                                      onPressed: () {
                                        if (otpVisibility) {
                                          verifyOTP();
                                        } else {
                                          loginWithPhone();
                                        }
                                      },
                                    child: Text(otpVisibility ? "Verification" : "Connexion")),



                                     Visibility(
                    child: FadeAnimation(
                    2,
                    
                    Container(
                      width: double.infinity,
                            height: 70,
                            margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),

                                  decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.purpleAccent, width: 1),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.purpleAccent,
                                        blurRadius: 10,
                                        offset: Offset(1, 1)),
                                  ],
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                            const Icon(Icons.code),  
                            Container(
                               margin: const EdgeInsets.only(left: 10),
                              child: TextFormField(
                                  controller: otpController,
                                  
                                      keyboardType: TextInputType.number,
                                        maxLines: 1,
                                        
                                        decoration: const InputDecoration(
                                          label: Text(" Code ..."),
                                          border: InputBorder.none,
                                          
                                        ),
                                 
                                              
                                  ),
                            ),
                              

                            
                        ])
                       )   ,
                  ),
                  visible: otpVisibility,),






                  *************rubriqeu*********
                  child: Row(
                                        children: <Widget>[
                                          SizedBox(
                                            height: 40,
                                            width: 100,
                                            //child: Text("Sized box content"),
                                          ),
                                          Container(
                                            height: 50,
                                            //width: MediaQuery.of(context).size.width,
                                            color: Colors.blue,
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: Text(
                                              doc['nom'],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 25,
                                              ),
                                            ),
                                          )
                                        ],
                                        //alignment: Alignment.bottomCenter,
                                        //width: 400.0,
                                        // margin: const EdgeInsets.all(30.0),

                                        //padding: const EdgeInsets.only(bottom: 1),
                                      ),

                                      child: Text(
                                              
                                              doc['nom'],
                                              
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                backgroundColor: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 25,
                                              ),
                                            ),
                                          
                                          child:Text("Hello World, Text 4"),
                                                 alignment: Alignment.center,
                                                    child: Column(
                                               mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                              Container(
                                                
                                                width: double.infinity,
                                                height: 100.0,
                                                margin: const EdgeInsets.all(10.0),
                                                color: Colors.amber[600],
                                               
                                                
                                                
                                                
                                              ),
                                              
                                            ]),
                                          *****************************RUBRIQUE***********************
                                          import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hidable/hidable.dart';
import 'package:scomv1/screens/authenticate/register.dart';
import 'package:scomv1/screens/pages/sousRubrique.dart';
//import 'package:provider/provider.dart';

class Rubriques extends StatefulWidget {
  @override
  ListeRubrique createState() => ListeRubrique();
}

class ListeRubrique extends State<Rubriques> {
  int _currentIndex = 0;
  List<Widget> pages = [
    Rubriques(),
    Text("Nouvelle page"),
  ];
  int index = 0;
  final FirebaseAuth auth = FirebaseAuth.instance;
  //signout function
  signOut() async {
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Register()));
  }

  Future<QuerySnapshot> rubriques =
      FirebaseFirestore.instance.collection('Rubriques').get();

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return DefaultTabController(
        length: 6,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            toolbarHeight: 110,

            centerTitle: true,
            //leading: Icon(Icons.person_outline),

            title: Text(
              'Accueil',
              style: TextStyle(fontSize: 16.0),
            ),
            bottom: PreferredSize(
                child: Container(
                  /*decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 22, 70, 228),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50))),*/

                  child: TabBar(
                      isScrollable: true,
                      unselectedLabelColor: Colors.white.withOpacity(0.3),
                      indicatorColor: Colors.white,
                      tabs: [
                        Tab(
                          child: Text('Tab 1'),
                        ),
                        Tab(
                          child: Text('Investment'),
                        ),
                        Tab(
                          child: Text('Your Earning'),
                        ),
                        Tab(
                          child: Text('Current Balance'),
                        ),
                        Tab(
                          child: Text('Tab 5'),
                        ),
                        Tab(
                          child: Text('Tab 6'),
                        )
                      ]),
                ),
                preferredSize: Size.fromHeight(30.0)),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
              ),
              new IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  signOut();
                },
              )
            ],
          ),
          /* AppBar(
          
          title: Text('Accueil'),
          actions: [
            new IconButton(
              icon: new Icon(Icons.logout),
              highlightColor: Colors.pink,
              onPressed: (){signOut();},
            ),
            
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ],
      ),*/

          drawer: Drawer(
            // Add a ListView to the drawer. This ensures the user can scroll
            // through the options in the drawer if there isn't enough vertical
            // space to fit everything.
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text('Oflutter.com'),
                  accountEmail: Text('example@gmail.com'),
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                      child: Image.network(
                        'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
                        fit: BoxFit.cover,
                        width: 90,
                        height: 90,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.favorite),
                  title: Text('Favorites'),
                  onTap: () => null,
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Friends'),
                  onTap: () => null,
                ),
                ListTile(
                  leading: Icon(Icons.share),
                  title: Text('Share'),
                  onTap: () => null,
                ),
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text('Request'),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () => null,
                ),
                ListTile(
                  leading: Icon(Icons.description),
                  title: Text('Policies'),
                  onTap: () => null,
                ),
                Divider(),
                ListTile(
                  title: Text('Exit'),
                  leading: Icon(Icons.exit_to_app),
                  onTap: () => null,
                ),
              ],
            ),
          ),
          body: Padding(
              padding: EdgeInsets.only(
                  left: 15.0, top: 15.0, right: 15.0, bottom: 10.0),
              child: StreamBuilder<QuerySnapshot>(builder:
                  (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                return FutureBuilder<QuerySnapshot>(
                    future: rubriques,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final List<DocumentSnapshot> documents =
                            snapshot.data!.docs;

                        return ListView(
                          controller: scrollController,
                            children: documents
                                .map((doc) => GestureDetector(
                                    onTap: () => {
                                          debugPrint('Navigation en cour.'),
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SousRubriques(
                                                      documentId: doc.id),
                                            ),
                                          )
                                        },
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        elevation: 5,
                                        child: Container(
                                          height: 250,
                                          width: double.infinity,
                                          decoration: BoxDecoration(

                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      doc['image']))
                                          ),
                                        child: Column(
                                               mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                              
                                               Positioned(
                                                bottom: 0,
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 55,
                                                  color: Color.fromARGB(179, 32, 115, 240),
                                                  child: Text(
                                                    doc["nom"],
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 24
                                                      ),
                                                    ),
                                                  alignment: Alignment.center, 
                                                ),
                                              )
                                              
                                            ]),
                                         

                                        
                                          clipBehavior: Clip.antiAlias,
                                        )
                                        ),
                                       
                                        )
                                        )
                                .toList());
                      } else if (snapshot.hasError) {
                        return Text("faux");
                      }
                      return CircularProgressIndicator();
                    });
              })),
          bottomNavigationBar:Hidable(
              controller: scrollController,
              wOpacity: true, // As default it's true
              size: kBottomNavigationBarHeight, // As default it's same.
              child: BottomNavigationBar(
                currentIndex: index,
                onTap: (i) => setState(() => index = i),
                items: bottomBarItems(),
              ),)
            
          ),
        );
  }
  List<BottomNavigationBarItem> bottomBarItems() {
    return [
      BottomNavigationBarItem(
        label: 'Home',
        icon: const Icon(Icons.home, color: Color.fromARGB(255, 12, 109, 219)),
        
      ),
      BottomNavigationBarItem(
        label: 'Favorites',
        icon: const Icon(Icons.favorite, color: Color.fromARGB(255, 12, 109, 219)),
       
      ),
      BottomNavigationBarItem(
        label: 'Profile',
        icon: const Icon(Icons.person, color: Color.fromARGB(255, 12, 109, 219)),
       
      ),
      BottomNavigationBarItem(
        label: 'Settings',
        icon: const Icon(Icons.settings, color: Color.fromARGB(255, 12, 109, 219)),
       
      ),
    ];
  }
}

****************bottom bar****************
   bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Color.fromARGB(252, 251, 251, 251),
            selectedItemColor: Color.fromARGB(255, 24, 133, 244),
            unselectedItemColor:
                Color.fromARGB(255, 24, 133, 244).withOpacity(.60),
            selectedFontSize: 14,
            unselectedFontSize: 14,
            currentIndex:
                _currentIndex, // this will be set when a new tab is tapped
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.mail),
                label: 'Messages',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profile')
            ],
          ),

          ****************Sous rubrique**************
          import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scomv1/screens/pages/demande.dart';
import 'package:scomv1/screens/pages/prestation.dart';

class SousRubriques extends StatelessWidget {
  @override
  final String documentId;

  SousRubriques({Key? key, required this.documentId}) : super(key: key);

  Widget build(BuildContext context) {
    Future<QuerySnapshot<Map<String, dynamic>>> rubriques = FirebaseFirestore
        .instance
        .collection('Rubriques')
        .doc(documentId)
        .collection("sous-rubriques")
        .get();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          } 

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          return FutureBuilder<QuerySnapshot>(
              future: rubriques,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<DocumentSnapshot> documents = snapshot.data!.docs;
                  return ListView(
                      children: documents
                          .map((doc) => GestureDetector(
                              onTap: () => {
                                    showDialog<String>(
                                      // barrierColor: Colors.transparent,
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        //title: const Text('AlertDialog Title'),
                                        //content: const Text('AlertDialog description'),

                                        actions: <Widget>[
                                          Column(
                                            children: [
                                              SizedBox(),
                                              ElevatedButton.icon(
                                                // <-- ElevatedButton
                                                onPressed: () {
                                                  
                                                   Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => Demande(detailId: doc.id)),
                                                    );
                                                },

                                                icon: Icon(
                                                  Icons.add_circle,
                                                  //borderRadius: BorderRadius.circular(100),
                                                  size: 24.0,
                                                  color: Colors.blue,
                                                ),
                                                label: Text(
                                                  'Faire une demande',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.blue),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Color.fromARGB(
                                                      255, 245, 247, 248),
                                                  fixedSize:
                                                      const Size(208, 43),
                                                ),
                                              ),
                                              ElevatedButton.icon(
                                                // <-- ElevatedButton
                                                onPressed: () {
                                                   Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => Prestation(detailId: doc.id)),
                                                    );
                                                },

                                                icon: Icon(
                                                  Icons.add_circle,
                                                  size: 24.0,
                                                  color: Colors.blue,
                                                ),
                                                label: Text(
                                                  'Proposer un service',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.blue),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Color.fromARGB(
                                                      255, 245, 247, 248),
                                                  fixedSize:
                                                      const Size(208, 43),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  },
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                child: Column(children: [
                                  ListTile(
                                    title: Text('doc.id: ${doc.id}'),
                                    subtitle:
                                        Text('category:     ${doc['nom']}'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      'Greyhound divisively hello coldly wonderfully marginally far upon excluding.',
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.6)),
                                    ),
                                  ),
                                  Image.network(doc['image']),
                                ]),
                              )
                              ))
                          .toList());
                } else if (snapshot.hasError) {
                  return Text("faux");
                }
                return CircularProgressIndicator();
              });
        }),
      ),
    );
  }
}

*************diialog*********
 children: [
                                                  SizedBox(),
                                                  
                                                  ElevatedButton.icon(
                                                    // <-- ElevatedButton
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                Demande(
                                                                    detailId:
                                                                        doc.id)),
                                                      );
                                                    },

                                                    icon: Icon(
                                                      Icons.add_circle,
                                                      //borderRadius: BorderRadius.circular(100),
                                                      size: 24.0,
                                                      color: Colors.blue,
                                                    ),
                                                    label: Text(
                                                      'Faire une demande',
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.blue),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Color.fromARGB(
                                                          255, 245, 247, 248),
                                                      fixedSize:
                                                          const Size(208, 43),
                                                    ),
                                                  ),
                                                  ElevatedButton.icon(
                                                    // <-- ElevatedButton
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                Prestation(
                                                                    detailId:
                                                                        doc.id)),
                                                      );
                                                    },

                                                    icon: Icon(
                                                      Icons.add_circle,
                                                      size: 24.0,
                                                      color: Colors.blue,
                                                    ),
                                                    label: Text(
                                                      'Proposer un service',
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.blue),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Color.fromARGB(
                                                          255, 245, 247, 248),
                                                      fixedSize:
                                                          const Size(208, 43),
                                                    ),
                                                  ),
                                                ],

                                                
                                                                
                                                                borderSide: BorderSide(color: Colors.blue),
                                                                textColor: Colors.blue,
                                                                color: Color.fromARGB(255, 3, 133, 209),
                                                                child: new Text("Proposer un service"),
                                                                
                                                                
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(20)),


                                                                    -*****************annonce**********
                                                                    child: Card(
                              child: Container(
                                height: 250,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(doc['photos'][0]))
                                        ),
                                child: Row(children: <Widget>[
                                  Container(
                                    height: 50,
                                    //width: MediaQuery.of(context).size.width,
                                    color: Colors.blue,
                                    //padding: const EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      doc['libelle'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 25,
                                      ),
                                    ),
                                  )
                                ]),
                                clipBehavior: Clip.antiAlias,
                              ),
                            )
                                    
                                                             
                          //Image.network(data['photos'][1]),
                         /*Column(
                            children: <Widget>
                              [
                                for (int i = 0;
                                i < data["photos"].length;
                                Image.network(data['photos'][i]),
                                i++)
                                 Text("sdvfvd $i"),
                                  ListTile(
                                  title: Text('titre: ${data['description']}'),
                                  subtitle: Image.network(data['photos'][i],
                                  ),
                                ),
                                  
                                  
                              ],
                            )*/


                             Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(data['photos'][0]))),
                    ),


                           Column(
                            children: <Widget>
                              [
                                for (int i = 0; i < data["photos"].length; i++)
                              
                            
                                 Text(data['photos'][i]),
                                  Container(
                                              height: 50,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                          data['photos'][i]))),
                                            ),
                                  
                                  
                              ],
                            )  


                  *******************Accordeon*****************
                  import 'package:firebase_auth/firebase_auth.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter/material.dart';
import 'package:scomv1/screens/authenticate/register.dart';

class ListeDemande extends StatefulWidget {
  const ListeDemande({Key? key}) : super(key: key);

  @override
  State<ListeDemande> createState() => _ListeDemandeState();
}

class _ListeDemandeState extends State<ListeDemande> {
  @override
    final FirebaseAuth auth = FirebaseAuth.instance;
    signOut() async {
      await auth.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Register()));
    }

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            toolbarHeight: 110,

            centerTitle: true,
            //leading: Icon(Icons.person_outline),

            title: Text(
              'Proposer un service',
              style: TextStyle(fontSize: 22.0),
            ),
            bottom: PreferredSize(
                child: Container(
                  /*decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 22, 70, 228),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50))),*/

                  child: TabBar(
                      isScrollable: true,
                      unselectedLabelColor: Colors.white.withOpacity(0.3),
                      indicatorColor: Colors.white,
                      tabs: [
                        Tab(
                          child: Text('Tab 1'),
                        ),
                        Tab(
                          child: Text('Investment'),
                        ),
                        Tab(
                          child: Text('Your Earning'),
                        ),
                        Tab(
                          child: Text('Current Balance'),
                        ),
                        Tab(
                          child: Text('Tab 5'),
                        ),
                        Tab(
                          child: Text('Tab 6'),
                        )
                      ]),
                ),
                preferredSize: Size.fromHeight(30.0)),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
              ),
              new IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  signOut();
                },
              )
            ],
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text('Oflutter.com'),
                  accountEmail: Text('example@gmail.com'),
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                      child: Image.network(
                        'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
                        fit: BoxFit.cover,
                        width: 90,
                        height: 90,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.favorite),
                  title: Text('Favorites'),
                  onTap: () => null,
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Friends'),
                  onTap: () => null,
                ),
                ListTile(
                  leading: Icon(Icons.share),
                  title: Text('Share'),
                  onTap: () => null,
                ),
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text('Request'),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () => null,
                ),
                ListTile(
                  leading: Icon(Icons.description),
                  title: Text('Policies'),
                  onTap: () => null,
                ),
                Divider(),
                ListTile(
                  title: Text('Exit'),
                  leading: Icon(Icons.exit_to_app),
                  onTap: () => null,
                ),
              ],
            ),
          ),

          
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
          child: Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: <Widget>[

                const GFAccordion(
                  title: 'GF Accordion',
                  content: 'GetFlutter is an open source library that comes with pre-build 1000+ UI components.',
                  collapsedIcon: Icon(Icons.add),
                  expandedIcon: Icon(Icons.minimize)
                  
              ),
            ]
          )
        )  

      )
    );
  }
}
************fichier main-------------

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scomv1/screens/authenticate/register.dart';
import 'package:scomv1/screens/pages/brouillon.dart';
import 'package:scomv1/screens/pages/editrofil.dart';
import 'package:scomv1/screens/pages/listeElement/listAnnonce.dart';
import 'package:scomv1/screens/pages/profil.dart';
import 'package:scomv1/screens/pages/rubriques.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  // runApp(const MyApp());
}

const String page1 = "Accueil";
const String page2 = "Anonces";
const String page3 = "Profile";
const String title = "Demo";

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: title,
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  //signout function
  signOut() async {
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Register()));
  }

  

  late List<Widget> _pages;
  late Widget _page1;
  late Widget _page2;
  late Widget _page3;
  late int _currentIndex;
  late Widget _currentPage;
  

  @override
  void initState() {
    super.initState();
    _page1 = ListeRubrique();
    _page2 = Anonces();
    _page3 = CreateProfil(userId: user!.uid,);
    //_page3 = Page3(changePage: _changeTab);
    _pages = [_page1, _page2, _page3];
    _currentIndex = 0;
    _currentPage = _page1;
  }

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
      _currentPage = _pages[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 6,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 110,

            centerTitle: true,
            //leading: Icon(Icons.person_outline),

            title: Text(
              'Proposer une prestation',
              style: TextStyle(fontSize: 24.0),
            ),
            bottom: PreferredSize(
                child: Container(
                  /*decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 22, 70, 228),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50))),*/

                  child: TabBar(
                      isScrollable: true,
                      unselectedLabelColor: Colors.white.withOpacity(0.3),
                      indicatorColor: Colors.white,
                      tabs: [
                        Tab(
                          child: Text('Tab 1'),
                        ),
                        Tab(
                          child: Text('Investment'),
                        ),
                        Tab(
                          child: Text('Your Earning'),
                        ),
                        Tab(
                          child: Text('Current Balance'),
                        ),
                        Tab(
                          child: Text('Tab 5'),
                        ),
                        Tab(
                          child: Text('Tab 6'),
                        )
                      ]),
                ),
                preferredSize: Size.fromHeight(30.0)),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
              ),
              new IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  signOut();
                },
              )
            ],
          ),
          body: _currentPage,
          bottomNavigationBar: BottomNavigationBar(
              onTap: (index) {
                _changeTab(index);
              },
              currentIndex: _currentIndex,
              items: const [
                BottomNavigationBarItem(
                  label: page1,
                  icon: Icon(Icons.home),
                ),
                BottomNavigationBarItem(
                  label: page2,
                  icon: Icon(Icons.home_repair_service),
                ),
                BottomNavigationBarItem(
                  label: page3,
                  icon: Icon(Icons.person),
                ),
              ]),
          drawer: Drawer(
            child: Container(
              margin: const EdgeInsets.only(top: 15.0),
              child: Column(
                children: <Widget>[
                  _navigationItemListTitle(page1, 0),
                  _navigationItemListTitle(page2, 1),
                  _navigationItemListTitle(page3, 2),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _navigationItemListTitle(String title, int index) {
    return ListTile(
      title: Text(
        '$title Page',
        style: TextStyle(color: Colors.blue[400], fontSize: 22.0),
      ),
      onTap: () {
        Navigator.pop(context);
        _changeTab(index);
      },
    );
  }
}





import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scomv1/screens/authenticate/login.dart';
import 'package:scomv1/screens/authenticate/register.dart';
import 'package:scomv1/screens/pages/createAnnonces.dart';
import 'package:scomv1/screens/pages/createProfil.dart';
import 'package:scomv1/screens/pages/aSupprimer/demande.dart';
import 'package:scomv1/screens/pages/detailAnonce.dart';
import 'package:scomv1/screens/pages/editrofil.dart';
//import 'package:scomv1/screens/pages/listAnnonce.dart';
import 'package:scomv1/screens/pages/listeElement/listeDemande.dart';
import 'package:scomv1/screens/pages/aSupprimer/prestation.dart';
import 'package:scomv1/screens/pages/profil.dart';
import 'package:scomv1/screens/pages/rubriques.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (_, snapshot) {
            if (snapshot.data == null) {
              return const Register();
            }

            User? user = FirebaseAuth.instance.currentUser;
            //if user isn't signed in

            return CreateProfil(userId: user!.uid);
            //return Rubriques();
            //if user is signed in
          }),
    );
  }
}










import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scomv1/screens/authenticate/login.dart';
import 'package:scomv1/screens/authenticate/register.dart';
import 'package:scomv1/screens/pages/createAnnonces.dart';
import 'package:scomv1/screens/pages/createProfil.dart';
import 'package:scomv1/screens/pages/aSupprimer/demande.dart';
import 'package:scomv1/screens/pages/detailAnonce.dart';
import 'package:scomv1/screens/pages/editrofil.dart';
import 'package:scomv1/screens/pages/listAnnonce.dart';
import 'package:scomv1/screens/pages/listeElement/listeDemande.dart';
import 'package:scomv1/screens/pages/aSupprimer/prestation.dart';
import 'package:scomv1/screens/pages/profil.dart';
import 'package:scomv1/screens/pages/rubriques.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (_, snapshot) {
            if (snapshot.data == null) {
              return const Register();
            }

            User? user = FirebaseAuth.instance.currentUser;
            //if user isn't signed in

            //return CreateProfil(userId: user!.uid);
            return Rubriques();
            //if user is signed in
          }),
    );
  }
}



 FirebaseFirestore.instance
        .collection('Utilisateurs')
        .doc("9R5LI2kBI5dKCXrpyjxZEfkb6L33")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var names = documentSnapshot["nom"];
         setState(() {
          
          nom = documentSnapshot["nom"];
          prenom = documentSnapshot["prenom"];
          email = documentSnapshot["email"];
          photo = documentSnapshot["photo"];
          
         
        });
        print('Document data: ${photo}');
        //Set the relevant data to variables as needed
      } else {
        print('Document does not exist on the database');
      }
    });


***************** splash *************
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scomv1/screens/authenticate/register.dart';
import 'package:scomv1/screens/pages/accueil.dart';
import 'package:scomv1/screens/pages/rubriques.dart';
import 'package:splashscreen/splashscreen.dart';

Future<void> main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
  // runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return  SplashScreen(
      seconds: 14,
      navigateAfterSeconds:  AfterSplash(),
      title:  Text(
        'Welcome In SplashScreen',
        style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      image:  Image.network(
          'https://cdn.pixabay.com/photo/2016/04/02/21/01/earth-1303628_960_720.png'),
      backgroundColor: Colors.white,
      loaderColor: Colors.red,
    );
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (_, snapshot) {
            if (snapshot.data == null) {
              return const Register();
            }

            User? user = FirebaseAuth.instance.currentUser;
            //if user isn't signed in

            //return CreateProfil(userId: user!.uid);
            return ListeRubrique();
            //if user is signed in
          }),
    );
  }
}

                           */
                          */