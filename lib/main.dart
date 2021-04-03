

import 'package:flutter/material.dart';
import 'package:flutter_app/news.dart';
void main() =>runApp(MaterialApp(
  home:Quotelist()

));
class home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      
      appBar: AppBar(
        centerTitle: true,
        title: Text("first App"),
        backgroundColor: Colors.deepPurple,
      ),
      
      body: Center(
        child:Image.asset('lib/assets/shiv.jpg')


      ),


      floatingActionButton: FloatingActionButton(
        child: Text("Click"),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}

class Quotelist extends StatefulWidget {
  @override
  _QuotelistState createState() => _QuotelistState();
}

class _QuotelistState extends State<Quotelist> {
  List <news>newslist=[
    news(description: "redmi lauched",author:"vinay"),
    news(description: "realme lauched", author:"sanchit"),
    news(description: "poco lauched", author: "yatin"),


  ];
Widget Newsextract(newx){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      elevation: 10.0,
      margin: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Icons.new_releases_rounded,
          size: 30.0,
          color: Colors.deepPurple,),
          Text(
            newx.description,
           style: TextStyle(
             letterSpacing: 2.0,
             fontSize: 18.0,
             color: Colors.grey

           ),
          ),
          Text(
            newx.author,
            style: TextStyle(
                letterSpacing: 2.0,
                fontSize: 18.0,
                color: Colors.grey

            ),
          ),
        ],
      ),
      borderOnForeground: true,
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
        centerTitle: true,
        title: Text("news"),
    backgroundColor: Colors.deepPurple,
    ),

    body: Column(
      children: newslist.map((news)=>Newsextract(news)).toList(),
    ),
        backgroundColor: Colors.cyan,

    );
  }
}




