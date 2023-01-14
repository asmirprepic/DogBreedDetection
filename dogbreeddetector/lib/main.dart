import 'package:dogbreeddetector/classifyFunc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io' as i;
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'classifier.dart';
import 'package:image/image.dart' as img;
import 'package:logger/logger.dart';
import 'package:dogbreeddetector/classifier.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart' as flhelp;




void main() {
  runApp(MaterialApp(
      home: Home(),
      ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Classifier _classifier =ClassifierFunc();
  
  var logger = Logger();

  final picker = ImagePicker();
  bool _loading = true;
  i.File  _image   = i.File('');
  List _output = [];

  late flhelp.Category category;
  
  Image? _imageWidget;

  img.Image? fox;

 


  @override
    void initState() {
    super.initState();
    
    
  }

  pickImage() async {
    var image = await picker.pickImage(source: ImageSource.camera,preferredCameraDevice: CameraDevice.rear);
    
    if (image==null) return null;

    setState(() {
      _image = i.File(image.path);
      _loading = false;

      _predict();
    });
   // _classifier.predict(_image);
  }

  pickGalleryImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);

    if (image==null) return null;
    

    setState(() {
      _image = i.File(image.path);
      _loading=false;
      _predict();
      print(category.label);
    });
    //classifier.classifyImage(_image);
  }

  void _predict() async {
    img.Image imageInput = img.decodeImage(_image.readAsBytesSync())!;
    var pred = _classifier.predict(imageInput);
    
    setState(() {
      this.category = pred;
    });
  }

  

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    print(_loading);
    print(_image);

    return Scaffold(
      body: Container(    
        child: Container(

        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topRight,end: Alignment.bottomLeft, colors: [Colors.pink,Colors.blue],)
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child:Center(
                child:
                 _loading==true
                ? Container(child: SizedBox(height:size.height-300),)
                : Container(
                  child: Column(
                    children: [
                    SizedBox(height: size.height-700),
                    Container(
                      height:300,
                      width: size.width,
                      child: Image.file(_image,
                      fit:BoxFit.cover
                      ), 
                    ),
                    SizedBox(
                      height: 25,
                    
                    ),
                    _output != null 
                    ? Container( child: Column( children: [Text ('Predicted Breed: ${category.label}'
                    ,style: TextStyle(
                      color: Colors.white,
                      fontSize:18,
                      fontWeight: FontWeight.bold)
                      ,),
                      SizedBox(height: size.height-700,)
                      ]
                      ),)
                      : Container(child:SizedBox(height: size.height-700)),
                      
                  ],
                  )
                )
              ,)
            ),
          //SizedBox(height: size.height-92),
          Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap:pickImage,
                  child:Container(
                    width: size.width-250,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 24,vertical: 17),
                    decoration: BoxDecoration(
                    color:Colors.transparent,
                    borderRadius: BorderRadius.vertical(),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Text(
                    'Camera',
                    style: TextStyle(color:Colors.white,fontSize:14),

                  ),
                  ),
                ),
                SizedBox(
                  width:30,
                  ),
                  GestureDetector(onTap:pickGalleryImage,
                  child: Container(
                    width:size.width-250,
                    alignment: Alignment.center,
                    padding:
                    EdgeInsets.symmetric(horizontal: 24,vertical:17),
                    decoration: BoxDecoration(
                      color:Colors.transparent,
                      borderRadius: BorderRadius.vertical(),
                      border: Border.all(color: Colors.white)
                    ),
                    child: Text(
                      'Gallery',
                      style: TextStyle(color:Colors.white,fontSize:14),
                    ),
                  ),
                  ),
              ],
            ),
            ),
          ],
        ),
        ),
        
    ),
    );
  }

}
