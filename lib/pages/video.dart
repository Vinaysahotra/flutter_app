import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class video extends StatefulWidget {
  var  id, name ,views;
 video(this.id,this.name,this.views);

  @override
  _videoState createState() => _videoState(id,name,views);
}


class _videoState extends State<video> {
  var id;
  var name;
  var views;
  YoutubePlayerController _controller;
  _videoState(this.id,this.name,this.views);
  @override
  void initState() {
 initializevideo();
    super.initState();
  }

  initializevideo() async{
    print("$id $name $views");
    _controller=  YoutubePlayerController(initialVideoId: id,flags: YoutubePlayerFlags(isLive: false,enableCaption: false,autoPlay: false));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return YoutubePlayerBuilder(player: YoutubePlayer(controller: _controller,), builder:(context,player){
return Scaffold(
  body: _controller.value!=null?Column(
    children: [
      SafeArea(child:player),
      SizedBox(height: 20,),
      Text(name,textScaleFactor: 1.5,style: TextStyle(color: Colors.orange),textAlign: TextAlign.left,),
      SizedBox(height: 20,),
      Text("Views  :${views}",textAlign: TextAlign.left,)
    ],
  ):Center(child: CircularProgressIndicator(),),
);
    });
  }
  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }
}
