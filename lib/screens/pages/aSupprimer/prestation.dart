import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hidable/hidable.dart';
import 'package:scomv1/screens/authenticate/register.dart';
import '../../../codeRepete/constants.dart';

class Prestation extends StatefulWidget {
  final String detailId;
  Prestation({required this.detailId});

  @override
  State<Prestation> createState() => _PrestationEvoie();
}

class _PrestationEvoie extends State<Prestation> {
  final CollectionReference demande =
      FirebaseFirestore.instance.collection('Prestations');
      final FirebaseAuth auth = FirebaseAuth.instance;
      final ScrollController scrollController = ScrollController();

    signOut() async {
      await auth.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Register()));
    }
    
  final _formKey = GlobalKey<FormState>();
  String sujet = "";
  String cabinet = "";
  String specialite = "";
  String description = "";
  String sousRubtique = "";
  String users = "";

  int index=0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 6,
        child:Scaffold(
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
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecorationDemande.copyWith(hintText: 'Sujet'),
                validator: (val) => val!.isEmpty ? 'ENTRE UN sujet' : null,
                onChanged: (val) {
                  setState(() => sujet = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecorationDemande.copyWith(hintText: 'Cabinet'),
                validator: (val) => val!.isEmpty ? 'Champ obligatoire' : null,
                onChanged: (val) {
                  setState(() => cabinet = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecorationDemande.copyWith(hintText: 'Specialité'),
                validator: (val) => val!.isEmpty ? 'Champ obligatoir' : null,
                onChanged: (val) {
                  setState(() => specialite = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                minLines: 5,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                  decoration: textInputDecorationDemande.copyWith(hintText: 'Description'),
                  validator: (val) =>
                      val!.length < 6 ? 'Champ obligatoir ' : null,
                  onChanged: (val) {
                    setState(() => description = val);
                  }),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),


                child: ElevatedButton.icon(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      demande.add({
                        "sujet": sujet,
                        "cabinet": cabinet,
                        "specialite":specialite,
                        "description":description,
                        "sousRubrique": widget.detailId,
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
                  icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                            
                            
                          ),
                         
                        label: Text("Soumettre",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),),

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
      ),
        bottomNavigationBar: Hidable(
              controller: scrollController,
              wOpacity: true, // As default it's true
              size: kBottomNavigationBarHeight, // As default it's same.
              child: BottomNavigationBar(
                currentIndex: index,
                onTap: (i) => setState(() => index = i),
                items: bottomBarItems(),
              ),
            ))
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
        icon: const Icon(Icons.favorite,
            color: Color.fromARGB(255, 12, 109, 219)),
      ),
      BottomNavigationBarItem(
        label: 'Profile',
        icon:
            const Icon(Icons.person, color: Color.fromARGB(255, 12, 109, 219)),
      ),
      BottomNavigationBarItem(
        label: 'Settings',
        icon: const Icon(Icons.settings,
            color: Color.fromARGB(255, 12, 109, 219)),
      ),
    ];
  }
}