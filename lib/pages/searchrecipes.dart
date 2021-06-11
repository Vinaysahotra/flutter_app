import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/recipedetails.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:http/http.dart'as http;

import 'mydrawer.dart';
class recipes extends StatefulWidget {
  const recipes({Key key}) : super(key: key);


  @override
  _recipesState createState() => _recipesState();
}

class _recipesState extends State<recipes> {
  var value;
  Icon cust= Icon(Icons.search);
  List result=[];
  Widget toobar=Text("Fit&Fine",style: TextStyle(color: Colors.white),);
  TextEditingController controller=TextEditingController();
  Future<void> searchrecipe(String query) async{
    try{

      var url=Uri.parse("https://api.spoonacular.com/recipes/complexSearch?query=$query&maxFat=90&number=1000&apiKey=a6172621cb65407197fe10095bfdc7f3");
      var resp =await http.get(url);
      value=jsonDecode(resp.body);
      result=value["results"];
      setState(() {});
    }
    catch(e){
      print(e);
    }
  }
  Future<void> setRecipes() async {
    try{

      var url=Uri.parse("https://api.spoonacular.com/recipes/complexSearch?query=all&maxFat=90&number=1000&apiKey=a6172621cb65407197fe10095bfdc7f3");
      var resp =await http.get(url);
      value=jsonDecode(resp.body);
       result=value["results"];
      setState(() {});

    }
    catch(e){
      print(e);
    }
    setState(() {
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
 setRecipes();

  }


  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      drawer: mydrawer(),
      backgroundColor: Colors.white,
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
                 searchrecipe(changed);
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
                setRecipes();
                cust= Icon(Icons.search);
                 toobar=Text("Recipes",style: TextStyle(color: Colors.white),);
              }

            });},
          )
        ],
      ),


     body: Center(
         child: value!=null?result.length!=0?ListView.builder(
itemCount: result.length,
  itemBuilder: (context,index){

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        splashColor: Colors.orange,
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder:(context)=>recipedetails(value["results"][index]["id"])));
        },
        child: Card(
          elevation: 10,

          shadowColor: Colors.orange,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(

              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

            Container(child: BlurHash(image: value["results"][index]["image"],),width: 300,height: 250,),
                Text("${value["results"][index]["title"]}",textScaleFactor: 1.0,style: TextStyle(color: Colors.orange,fontSize: 20,fontWeight: FontWeight.bold),),



              ],
            ),
          ),
        ),
      ),
    );

  },
):Text("no recipe found"):CircularProgressIndicator(backgroundColor: Colors.orange,))
    );
  }


}
