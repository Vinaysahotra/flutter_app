
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/pages/login.dart';
import 'package:flutter_app/pages/searchrecipes.dart';
import 'package:flutter_app/pages/shoppinglist.dart';
import 'package:lottie/lottie.dart';

import 'pages/calorieswise.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,

      routes:{
          "/":(context)=>splash(),
        "/login": (context)=>login(),
        "/calories" :(context)=>calories(),
        "/recipes":(context)=>recipes(),
        "/search": (context)=>recipes(),
        "/cart": (context)=>shoppinglist()

      }


  ));
}
class splash extends StatefulWidget {
  const splash({Key key}) : super(key: key);

  @override
  _splashState createState() => _splashState();
}

class _splashState extends State<splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
        Duration(seconds: 5),
            () {if( FirebaseAuth.instance.currentUser==null)Navigator.of(context).pushReplacementNamed("/login");
        else
              Navigator.of(context).pushReplacementNamed("/search");
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:ListView(
        children: [
          SizedBox(height: 90,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Lottie.asset("lib/assets/food-loading.json"),
          ),
          SizedBox(height: 20,),

          Center(child: Text("Fit&Fine",textScaleFactor: 2.0,style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold),)),
        ],
      ) ,
    );
  }
}
