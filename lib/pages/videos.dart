import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_app/pages/video.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class videos extends StatefulWidget {

  @override
  _videosState createState() => _videosState();
}

class _videosState extends State<videos> {
  var value;
  Icon cust= Icon(Icons.search);
  Widget toobar=Text("Videos",style: TextStyle(color: Colors.white),);
  TextEditingController controller=TextEditingController();
  @override
  void initState() {
   searchrecipevideo("all recipes");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: toobar,
            backgroundColor: Colors.orange,
            actions: <Widget>[
              IconButton(
                icon: cust,
                onPressed:(){setState(() {
                  if(this.cust.icon==Icons.search){
                    this.cust=Icon(Icons.cancel);
                    this.toobar=TextField(
                      controller: controller,

                      onSubmitted: (changed){
                        searchrecipevideo(changed);
                        setState(() {
                        });
                      },
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18
                      ),
                    );
                  }
                  else{
                    searchrecipevideo("all");
                    cust= Icon(Icons.search);
                    toobar=Text("Recipes",style: TextStyle(color: Colors.white),);
                  }

                });},
              )
            ],
          ),
        body: value!=null?SafeArea(
          child: ListView.builder(
              itemCount:value["videos"].length,
              itemBuilder: (context,index){

                return InkWell(
                  onTap:(){
                    setState(() {
                      Navigator.push(context, MaterialPageRoute(builder:(context)=>video(value["videos"][index]["youTubeId"],value["videos"][index]["title"],value["videos"][index]["views"])));
                    });
                  },
                  child: Card(

                    shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(12)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Stack(children: [  Image.network(value["videos"][index]["thumbnail"],height: 200,),Positioned(left:0,right:0,bottom:0,top:0,child: Icon(Icons.play_arrow_sharp,size: 40,color: Colors.white,))],),

                        Text(value["videos"][index]["title"],textScaleFactor: 1.2,style: TextStyle(color: Colors.black),textAlign:TextAlign.center,),
                        SizedBox(height: 10,),
                        Text("views : ${value["videos"][index]["views"]}",textScaleFactor: 1.0,)

                      ],
                    ),
                  ),
                );
              }),
        ):Center(child:CircularProgressIndicator(color: Colors.orange,))

      );
  }

  Future<void> searchrecipevideo(String changed) async {
    try{

      var url=Uri.parse("https://api.spoonacular.com/food/videos/search?query=${changed}&number=100&apiKey=a6172621cb65407197fe10095bfdc7f3");
      var resp =await http.get(url);
      value=jsonDecode(resp.body);

    }
    catch(e){
      print(e);
    }
    setState(() {
    });
  }

}
