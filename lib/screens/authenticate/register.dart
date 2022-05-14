import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scomv1/codeRepete/fade_animation.dart';
import '../pages/rubriques.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  bool otpVisibility = false;

  String verificationrecu = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              // Colors.purple,
              Color.fromARGB(255, 253, 252, 253),
              Color.fromARGB(255, 253, 253, 253),
            ])),

        child: Column(
          children: [
            
             Container(
                margin: const EdgeInsets.only(top: 100),
                child: const FadeAnimation(
                  2,
                  Text(
                    "LOGO",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 3, 86, 212),
                      letterSpacing: 3,
                    ),
                  ),
                )),
            // ignore: prefer_const_constructors
            Expanded(
              child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 0, 145, 234),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50))),
                  margin: const EdgeInsets.only(top: 60),

                child: SingleChildScrollView(
                   child: Column(
                      children: [
                        const SizedBox(
                          height: 110,
                        ),
                        Container(
                            // color: Colors.red,
                            alignment: Alignment.topCenter,
                            //margin: const EdgeInsets.only(left: 22, bottom: 20),
                            /*child: const FadeAnimation(
                              2,
                              Text(
                                "Connexion",
                                style: TextStyle(
                                    fontSize: 35,
                                    color: Color.fromARGB(221, 255, 254, 254),
                                    letterSpacing: 2,
                                    fontFamily: "Lobster"),
                              ),
                            )*/),
                  FadeAnimation(
                    2,
                          Container(
                            width: double.infinity,
                            height: 60,
                            margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),

                                  decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color.fromARGB(255, 255, 253, 255), width: 1),
                                  /*boxShadow: const [
                                    BoxShadow(
                                        color: Color.fromARGB(255, 239, 234, 240),
                                        blurRadius: 27,
                                        /*offset: Offset(1, 1)*/),
                                  ],*/
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30))),
                           child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.phone),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 10),

                                    child: TextFormField(
                                      controller: phoneController,
                                      keyboardType: TextInputType.phone,
                                        maxLines: 1,
                                        
                                        decoration: const InputDecoration(
                                          label: Text(" Téléphone ..."),
                                          border: InputBorder.none,
                                          
                                        ),
                                      ),
                                      

                  ))]))),
                  Visibility(
                    
                    child: FadeAnimation(
                    2,
                    
                    Container(
                      width: double.infinity,
                            height: 60,
                            margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),

                                  decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color.fromARGB(255, 255, 255, 255), width: 1),
                                  /*boxShadow: const [
                                    BoxShadow(
                                        color: Colors.purpleAccent,
                                        blurRadius: 10,
                                        offset: Offset(1, 1)),
                                  ],*/
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30))),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.numbers),
                          Expanded(
                              
                            child:Container(
                               margin: const EdgeInsets.only(left: 10),
                              child: TextFormField(
                                  controller: otpController,
                                  
                                      keyboardType: TextInputType.number,
                                        maxLines: 1,
                                        
                                        decoration: const InputDecoration(
                                          label: Text("Code..."),
                                          border: InputBorder.none,
                                          
                                        ),
                                 
                                              
                                  ),
                            ),
                          ),
                              

                            
                        ])
                       )   ,
                  ),
                  visible: otpVisibility,),
                    FadeAnimation(
                          2,
                          ElevatedButton(
                            onPressed: () {
                                        if (otpVisibility) {
                                          verifyOTP();
                                        } else {
                                          loginWithPhone();
                                        }
                                      },//child: Text(otpVisibility ? "Verification" : "Connexion"),
                                      
                            style: ElevatedButton.styleFrom(
                                onPrimary: Colors.blue,
                                //shadowColor: Colors.white,
                                elevation: 5,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            child: Ink(
                              decoration: BoxDecoration(
                                color: Colors.deepOrangeAccent,
                                  /*gradient: const LinearGradient(colors: [
                                    Colors.blue,
                                    Colors.blue
                                  ]),*/
                                  borderRadius: BorderRadius.circular(20)),
                              child: Container(
                                width: 200,
                                height: 50,
                                alignment: Alignment.center,
                                child: const Text(
                                  'Connexion',
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                             
                          ),
                        )
                ]))
              )
            )
          ],
        ),
      ),
    );
  }

  void loginWithPhone() async {
    auth.verifyPhoneNumber(
      phoneNumber: phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((value) {
          print("You are logged in successfully");
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        otpVisibility = true;
        verificationrecu = verificationId;
        setState(() {});
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationrecu, smsCode: otpController.text);

    await auth.signInWithCredential(credential).then((value) {
      print("You are logged in successfully");
      User? user = FirebaseAuth.instance.currentUser;

      FirebaseFirestore.instance.collection('Utilisateur').doc(user!.uid).set({"id":user.uid});

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListeRubrique(),
        ),
      );

      Fluttertoast.showToast(
          msg: "You are logged in successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }
}
