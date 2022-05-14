import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  //hintText:'Email',
  fillColor: Colors.white,
  
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromARGB(255, 2, 0, 0), width:2.0)
    
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.pink, width:2.0)
  ),
);

// Field design 
const textInputDecorationDemande = InputDecoration(
  //hintText:'Email',
  fillColor: Colors.white,
  
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromARGB(82, 119, 117, 117), width:1.0)
    
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromARGB(255, 28, 140, 245), width:1.0)
  ),
);

//text input profil
const textInputDecorationProfil = InputDecoration(
  //hintText:'Email',
  fillColor: Colors.white,
  
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromARGB(255, 2, 0, 0), width:1.0)
    
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromARGB(175, 14, 119, 255), width:1.0)
  ),
);
