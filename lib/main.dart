import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import './utility.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PickedFile? imageFile;
  String textVal = '';
  bool vt = false, ti = false;

  //TO GET A IMAGE FROM GALLERY
  Future getImage() async {
    final PickedFile? pickedImage = await ImagePicker()
        .getImage(source: ImageSource.gallery); //, imageQuality: 50

    setState(() {
      imageFile = pickedImage;
    });
  }


//DIALOG WHEN IMAGE/BASE64 STRING IS MISSING
  dialogShow(bool fromImg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title:
            fromImg ? Text("Base64 string empty") : Text("No image selected"),
        content: fromImg
            ? Text("Convert image to base64 and try again")
            : Text("Select image to convert to base64"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text("OKAY"),
          ),
        ],
      ),
    );
  }

//FUCTION TO CONCERT IMAGE TO BASE64
  toTextBtn(PickedFile? imageFile) async {
    if (imageFile != null) {
      try{
        textVal = Utility.base64(await imageFile.readAsBytes());
      }
      catch(E){
        print(E);
      }

    } else {
      dialogShow(false);
    }
    setState(() {
      print('Reached toText');
      ti = false;
      textVal == '' ? vt = false : vt = true;
    });
  }

  newFunc() {
    textVal == ''
        ? dialogShow(true)
        : setState(() {
            ti = true;
            vt = false;
          });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical, //.horizontal
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 32,
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  getImage();//_showPicker(context);
                },
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Color(0xffFDCF09),
                  child: imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.file(File(imageFile!.path)))
                      : Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(50)),
                          width: 100,
                          height: 100,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey[800],
                          ),
                        ),
                ),
              ),
            ),
            Text('1.Touch the circle and select a image'),
            ButtonBar(
              children: [
                TextButton(
                    onPressed: () => toTextBtn(imageFile),
                    child: Text('2.Convert image to text')),
                TextButton(
                    onPressed: () => newFunc(),
                    child: Text('3.Convert text to image'))
              ],
            ),
            if(vt) Text('Conversion to base64 successful'),
            if(ti) Utility.baseToImg(textVal) //CONVERTING BASE64 TO IMAGE
          ],
        ),
      ),
    );
  }
}
