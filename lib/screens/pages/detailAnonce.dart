import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scomv1/codeRepete/fade_animation.dart';
import 'package:scomv1/screens/chat/chat.dart';
import 'package:scomv1/screens/authenticate/register.dart';

class SingleAnonce extends StatelessWidget {
  @override
  final String anonceId;
 
  const SingleAnonce({required this.anonceId});

  Widget build(BuildContext context) {
    Future<dynamic> friendsList;
  final FirebaseAuth auth = FirebaseAuth.instance;

  int _currentIndex = 0;
   String userId = "";
  String nom = "";
  bool isLoading = false;


   signOut() async {
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Register()));
  }  

    CollectionReference anonces =
        FirebaseFirestore.instance.collection('Anonces');
  
  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

    return DefaultTabController(
        length: 6,
        child:Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            toolbarHeight: 110,

            centerTitle: true,
            //leading: Icon(Icons.person_outline),

            title: Text(
              'Annonce',
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
          child: FutureBuilder<DocumentSnapshot>(
            future: anonces.doc(anonceId).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return Text("Document does not exist");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;

                return Column(children: [
                  Container(
                    child: Card(
                      child: Column(
                        children: [
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(data['photos'][0]))),
                          ),
                          ListTile(
                            leading: const Icon(Icons.arrow_drop_down_circle),
                            title: Text(data['libelle']),
                            subtitle: Text(
                              data["description"],
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                          ButtonBar(
                                              alignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                FlatButton(
                                                  textColor:
                                                      const Color(0xFF6200EE),
                                                  onPressed: () {
                                                    String roomId = chatRoomId(
                                                        data["libelle"], anonceId);
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ChatRoom(
                                                          chatRoomId: roomId,
                                                          userId: data["annonceurId"],
                                                        ),
                                                      ),
                                                    );
                                                    print(userId);
                                                  },
                                                  child: const Text('Laisser un message'),
                                                ),
                                                
                                              ],
                                            ),
                          
                        ],
                      ),
                    ),
                  ),
                  
                   
                     Row(
                       
                      children: List.generate(data["photos"].length, (index) => 
                      FadeAnimation(
                    2,
                    
                      Container(
                        
                                height: 100,
                                width: 100,
                               
                                decoration: BoxDecoration(
                                  borderRadius:
                                                      BorderRadius.circular(
                                  15.0),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      data['photos'][index]))),
                                ),
                      )
                      
                      )
                      )
                    
                  
                ]);
              }

              return CircularProgressIndicator();
            },
          ),
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
    ));
  }
}
