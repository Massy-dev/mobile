// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';
import 'package:hidable/hidable.dart';
import 'package:scomv1/codeRepete/constants.dart';
import 'package:scomv1/screens/authenticate/register.dart';
import 'package:scomv1/screens/pages/brouillon.dart';
import 'package:scomv1/screens/pages/aSupprimer/demande.dart';
import 'package:scomv1/screens/pages/editrofil.dart';
import 'package:scomv1/screens/pages/aSupprimer/prestation.dart';
import 'package:scomv1/screens/pages/rubriques.dart';
import 'package:scomv1/screens/pages/sousRubrique.dart';
//import 'package:provider/provider.dart';

class ListeDemande extends StatefulWidget {
  final String detailId;
  ListeDemande({required this.detailId});

  @override
  State<ListeDemande> createState() => _ListeDemandeState();
}

class _ListeDemandeState extends State<ListeDemande> {
// Prestation élémént
  final CollectionReference demande =
      FirebaseFirestore.instance.collection('Prestations');
  

  final _formKey = GlobalKey<FormState>();
  String sujet = "";
  String cabinet = "";
  String specialite = "";
  String description = "";
  String sousRubtique = "";
  String users = "";

  User? user = FirebaseAuth.instance.currentUser;
  int selectedIndex = 0;
  //list of widgets to call ontap

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final widgetTitle = ["Accueil", "Profil"];

  final FirebaseAuth auth = FirebaseAuth.instance;
  //signout function
  signOut() async {
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Register()));
  }

  

  @override
  
  Widget build(BuildContext context) {
    Future<QuerySnapshot> rubriques = FirebaseFirestore.instance
      .collection('Demande')
      .where('sousRubrique', isEqualTo: widget.detailId)
      .get();
    final ScrollController scrollController = ScrollController();

    int _currentIndex = 0;
    return MaterialApp(
        
        home: DefaultTabController(
          length: 6,
          child: Scaffold(
              resizeToAvoidBottomInset: false,
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
              body: Container(
                padding: EdgeInsets.only(
                    left: 15.0, top: 15.0, right: 15.0, bottom: 10.0),
                child: Center(child: StreamBuilder<QuerySnapshot>(builder:
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
                                        child: GFAccordion(
                                            title: doc["sujet"],
                                            content: doc["message"],
                                            collapsedIcon:
                                                Icon(Icons.expand_more_rounded),
                                            expandedIcon: Icon(
                                                Icons.expand_less_rounded)),
                                      ))
                                  .toList());
                        } else if (snapshot.hasError) {
                          return Text("faux");
                        }
                        return CircularProgressIndicator();
                      });
                })),
              ),
              floatingActionButton: FloatingActionButton.extended(
                backgroundColor: Color.fromARGB(205, 15, 117, 241),
                foregroundColor: Color.fromARGB(255, 255, 254, 254),
                onPressed: () => {
                  showDialog<String>(
                    // barrierColor: Colors.transparent,
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      //title: const Text('AlertDialog Title'),
                      //content: const Text('AlertDialog description'),

                      actions: [
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true)
                                .pop(); // passing true
                          },
                          child: Text('Fermer'),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 20.0),
                              TextFormField(
                                decoration: textInputDecorationDemande.copyWith(
                                    hintText: 'Sujet'),
                                validator: (val) =>
                                    val!.isEmpty ? 'ENTRE UN sujet' : null,
                                onChanged: (val) {
                                  setState(() => sujet = val);
                                },
                              ),
                              SizedBox(height: 20.0),
                              TextFormField(
                                decoration: textInputDecorationDemande.copyWith(
                                    hintText: 'Cabinet'),
                                validator: (val) =>
                                    val!.isEmpty ? 'Champ obligatoire' : null,
                                onChanged: (val) {
                                  setState(() => cabinet = val);
                                },
                              ),
                              SizedBox(height: 20.0),
                              TextFormField(
                                decoration: textInputDecorationDemande.copyWith(
                                    hintText: 'Specialité'),
                                validator: (val) =>
                                    val!.isEmpty ? 'Champ obligatoir' : null,
                                onChanged: (val) {
                                  setState(() => specialite = val);
                                },
                              ),
                              SizedBox(height: 20.0),
                              TextFormField(
                                  minLines: 5,
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  decoration: textInputDecorationDemande
                                      .copyWith(hintText: 'Description'),
                                  validator: (val) => val!.length < 6
                                      ? 'Champ obligatoir '
                                      : null,
                                  onChanged: (val) {
                                    setState(() => description = val);
                                  }),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    // Validate returns true if the form is valid, or false otherwise.
                                    if (_formKey.currentState!.validate()) {
                                      demande.add({
                                        "sujet": sujet,
                                        "cabinet": cabinet,
                                        "specialite": specialite,
                                        "description": description,
                                        "sousRubrique": widget.detailId,
                                      }).then((_) {
                                        Text("Prestation soumit avec succès");
                                      });

                                      // If the form is valid, display a snackbar. In the real world,
                                      // you'd often call a server or save the information in a database.
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text('Envoie en cour')),
                                      );
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.send,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    "Soumettre",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blue,
                                    fixedSize: const Size(200, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                      backgroundColor: Color.fromARGB(255, 248, 244, 244),
                    ),
                  )
                },
                icon: Icon(Icons.add),
                label: Text('Poposez votre prestation'),
              ),
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
                icon: const Icon(Icons.home_rounded, color: Color.fromARGB(255, 12, 109, 219)),
                label: 'Home',
              ),
               BottomNavigationBarItem(
                  icon:const Icon(Icons.person_rounded, color: Color.fromARGB(255, 12, 109, 219)),
                  label: 'Profile'),
              BottomNavigationBarItem(
                icon: const Icon(Icons.message_rounded,
            color: Color.fromARGB(255, 12, 109, 219)),
                label: 'Messages',
              ),
              BottomNavigationBarItem(
                label: 'Notifications',
                icon: const Icon(Icons.notifications_active,
                    color: Color.fromARGB(255, 12, 109, 219)),
              ),
             
            ],
          ),
            
              ),
        ));
  }

}
