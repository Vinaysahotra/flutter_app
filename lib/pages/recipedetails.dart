import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;

class recipedetails extends StatefulWidget {
  int id;

  recipedetails(this.id);

  @override
  _recipedetailsState createState() => _recipedetailsState(id);
}

class _recipedetailsState extends State<recipedetails> {
  int id;
  var value;
  List ingredients;
  _recipedetailsState(this.id);

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    getdetails();
  }

  Future<void> getdetails() async {
    try {
      var url = Uri.parse(
          "https://api.spoonacular.com/recipes/${id}/information?includeNutrition=false&apiKey=a6172621cb65407197fe10095bfdc7f3");
      var resp = await http.get(url);
      value = jsonDecode(resp.body);
      ingredients = value["extendedIngredients"];
      print(ingredients.length);
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: value != null
          ? CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 200.0,
                  floating: true,

                  pinned: true,
                  backgroundColor: Colors.orange,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: value != null
                        ? Text(
                            "${value["title"]}",
                            textScaleFactor: 0.8,
                          )
                        : Text("wait"),
                    background: Container(
                      width: 300,
                      child: BlurHash(
                        image: value["image"],
                      ),
                    ),
                  ),
                ),
                buildcontent(),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget buildcontent() => SliverToBoxAdapter(
        child: Card(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.5)),
          child: ListView(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            children: [
              value["vegetarian"]
                  ? Text(
                      "Vegetarian",
                      textScaleFactor: 1.2,
                      style: TextStyle(color: Colors.green),
                    )
                  : Text(
                      "Non-vegetarian",
                      textScaleFactor: 1.2,
                      style: TextStyle(color: Colors.red),
                    ),
              SizedBox(
                height: 10,
              ),
              value["glutenFree"]
                  ? Text(
                      "Gluten Free : Yes",
                      style: TextStyle(color: Colors.orange),
                    )
                  : Text(
                      "Gluten Free :No",
                      style: TextStyle(color: Colors.orange),
                    ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Ready in ${value["readyInMinutes"]} minutes",
                style: TextStyle(color: Colors.orange),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Servings : ${value["servings"]}",
                style: TextStyle(color: Colors.orange),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Ingredients needed\n",
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.orange),
              ),
              ListView.builder(
                itemCount: ingredients.length,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Text(
                          '${ingredients[index]["name"]}( ${ingredients[index]["original"]})',
                          textAlign: TextAlign.left)
                    ],
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Instructions\n",
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.orange),
              ),
              Html(
                data: value["instructions"],
                shrinkWrap: true,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Summary\n",
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.orange),
              ),
              Html(
                data: value["summary"],
                shrinkWrap: true,
              ),
            ],
          ),
        ),
      );
}
