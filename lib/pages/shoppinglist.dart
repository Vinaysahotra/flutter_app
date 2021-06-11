

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cartItem.dart';

class shoppinglist extends StatefulWidget {
  const shoppinglist({Key key}) : super(key: key);

  @override
  _shoppinglistState createState() => _shoppinglistState();
}

class _shoppinglistState extends State<shoppinglist> {

  final formkey = GlobalKey<FormState>();
  List<cartItem>items=new List();
String product;
String product_price;
String quantity;
DatabaseReference reference=FirebaseDatabase.instance.reference().child("users").child(FirebaseAuth.instance.currentUser.uid);

@override
  void initState() {
  if(reference.child("cart")!=null)
  reference.child("cart").once().then((DataSnapshot snapshot){
    var keys=snapshot.value.keys;
    var values=snapshot.value;
    for(var key in keys){
      setState(() {
        items.add(new cartItem(values[key]["name"], values[key]["price"], values[key]["quantity"]));
      });

    }
  });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.orange,
        title: Text("Shopping cart"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add), backgroundColor: Colors.orange, onPressed: () {
        showDialog(context: context, builder: (BuildContext context) {
          return Dialog(

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 10.0,
            child: Container(
              height: 400,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Add the Product info.", textScaleFactor: 1.5,
                        style: TextStyle(color: Colors.orange),),
                      SizedBox(width: 20),
                      TextFormField(
onChanged: (value){
  setState(() {
    product=value;
  });

},
                        validator: (value) {
                          if (value.isEmpty) {
                            return "empty value";
                          }
                          else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            labelText: "Product name",
                             hintText: "enter here"

                        ),


                      ),
                      TextFormField(
onChanged: (price){
  product_price=price;
  setState(() {

  });
},

                        validator: (value) {
                          if (value.isEmpty) {
                            return "empty value";
                          }
                          else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            labelText: "Product prize",
                            hintText: "enter here"

                        ),


                      ),
                      TextFormField(
                        onChanged: (value){
                          quantity=value;
                          setState(() {

                          });
                        },

                        validator: (value) {
                          if (value.isEmpty) {
                            return "empty value";
                          }
                          else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            labelText: "Quantity",
                            hintText: "enter  here",
                        ),


                      ),
                      RaisedButton(color: Colors.orange, child: Text(
                          "Add to cart"), onPressed: () {
                        CircularProgressIndicator(backgroundColor: Colors.white);
                        if (formkey.currentState.validate()) {
                          addtocart();
                   Navigator.pop(context);
                        }

                      }),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },),
      body: items.length!=0?Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: ListView.builder(
            itemCount: items!=null?items.length:10,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(

title: Text(items[index].name,textScaleFactor: 1.5,style: TextStyle(color: Colors.orange),),

                  subtitle: Text(' price : ${items[index].price}  quantity :${items[index].quantity} ',textScaleFactor: 1.0,),

                  trailing:InkWell(child:Icon(Icons.delete) ,onTap: (){setState(() {
                    reference
                        .child('cart')
                        .orderByChild('name')
                        .equalTo(items[index].name)
                        .once()
                        .then((DataSnapshot snapshot) {
                      Map<dynamic, dynamic> children = snapshot.value;
                      children.forEach((key, value) {
                        reference
                            .child('cart')
                            .child(key)
                            .remove();
                      });

                    });
                  });
                  items.removeAt(index);
                  setState(() {});
                  },) ,
                )
              );
            }),
      ):Center(child:Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.no_food_rounded,color: Colors.grey,), Text("no item added",textScaleFactor: 1.2,style: TextStyle(color: Colors.grey),)],)),
    );
  }

  addtocart() async {
    final FormState formState = formkey.currentState;
    if (formState.validate()) {
      formState.save();
      cartItem item=new cartItem(product, product_price,quantity);
      reference.child("cart").push().set({'name':product,'price':product_price,'quantity':quantity}).asStream();
      setState(() {
        items.add(item);
      });

    }
  }
}
