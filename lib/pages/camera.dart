import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/preview.dart';

import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class camera extends StatefulWidget {
  const camera({Key key}) : super(key: key);

  @override
  _cameraState createState() => _cameraState();

}


class _cameraState extends State<camera> {
  CameraController cameraController;
  List camera;
  int selectedCameraIndex;
  String path;

  Future initCamera(CameraDescription description) async {
    if(cameraController!=null){
      await cameraController.dispose();

    }
    cameraController=CameraController(description,ResolutionPreset.high);
    cameraController.addListener(() { if(mounted){
      setState(() {});
    }
    });
    if(cameraController.value.hasError){
print("error:");
    }
    try{
      await cameraController.initialize();

    }on CameraException catch(e){
      show_camera_Exception(e);
    }
    if(mounted){
      setState(() {});
    }
  }
  Widget cameraPreview(){
    if(cameraController==null||!cameraController.value.isInitialized){
      return const Text(
        "Loading",
          style :TextStyle(color: Colors.white),
      );
    }
    return AspectRatio(aspectRatio: cameraController.value.aspectRatio,
    child: CameraPreview(cameraController),);
  }
  Widget CameraControl(context){
    return Expanded(child: Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          FloatingActionButton(
            child: Icon(
              Icons.camera,
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            onPressed: (){
              oncaptured(context);
            },
            
          )
        ],
      ),
    ));

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              Expanded(flex:1,child: cameraPreview(),),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 120,
                  width:double.infinity,
                  padding: EdgeInsets.all(15),
                  color: Colors.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CameraToggle(),
                      CameraControl(context),
                      Spacer()
                    ],
                  ),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget CameraToggle(){
    if(camera==null||camera.isEmpty){
      return Spacer();
    }
    CameraDescription selected=camera[selectedCameraIndex];
    CameraLensDirection lensDirection=selected.lensDirection;
    return Expanded(
    child: Align(
      alignment: Alignment.centerLeft,
      child: FlatButton.icon(onPressed: _onSwitchCamera , icon: Icon(getCameraLens(lensDirection),color: Colors.white,size: 24,), label: Text("${lensDirection.toString().substring(lensDirection.toString().indexOf('.')+1).toUpperCase()}")),
    ),
    );
  }
@override
  void initState() {

    super.initState();
    availableCameras().then((availableCameras){
      camera=availableCameras;
      if(camera.length>0) {
        setState(() {
          selectedCameraIndex = 0;
        });
        initCamera(camera[selectedCameraIndex]).then((void v) {});
      }
      else{
        print("No camera Avaiable");

      }
    }).catchError((err){
     print('Error : $err ');
    });

  }
  void show_camera_Exception(CameraException e) {
    String error="Error occured ${e.description}";
    print(error);
  }

  Future<void> oncaptured(context) async {
    try{
      final path=join((await getTemporaryDirectory() ).path,'${DateTime.now()}.png');
          await cameraController.takePicture(path);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=>preview(path,))
          );
    }
    catch(e){
      show_camera_Exception(e);
    }

  }

  IconData getCameraLens(CameraLensDirection lensDirection) {
    switch(lensDirection){
      case CameraLensDirection.back:
        return CupertinoIcons.switch_camera;
      case CameraLensDirection.front:
        return CupertinoIcons.switch_camera_solid;
      case CameraLensDirection.external:
        return CupertinoIcons.photo_camera;
      default:
        return Icons.device_unknown;


    }
  }

  void _onSwitchCamera() {
    selectedCameraIndex=selectedCameraIndex<camera.length-1?selectedCameraIndex+1:0;
    CameraDescription description =camera[selectedCameraIndex];
    initCamera(description);
  }
}

