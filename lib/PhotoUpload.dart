import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:blog/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';


class UploadPhotoPage extends StatefulWidget {
  @override
  _UploadPhotoPageState createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {

  File _sampleImage;
  String _myValue;
  final formKey = new GlobalKey<FormState>();
  PermissionStatus _status;
  String url;
  String mail='me';
  final FirebaseAuth auth = FirebaseAuth.instance;


  /*Future<bool> checkAndRequestCameraPermissions() async {
    PermissionStatus permission =
    await PermissionHandler().checkPermissionStatus(PermissionGroup.camera).then(_updateStatus);
    if (permission != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus> permissions =
      await PermissionHandler().requestPermissions([PermissionGroup.camera]);
      return permissions[PermissionGroup.camera] == PermissionStatus.granted;
    } else {
      return true;
    }
  }*/
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PermissionHandler().checkPermissionStatus(PermissionGroup.camera).then(_updateStatus);
  }
  void _updateStatus(PermissionStatus status){
    if(status!=_status){
      setState(() {
        _status=status;
      });
    }
  }
  void _askPermission(){
    PermissionHandler().requestPermissions([PermissionGroup.camera]).then(_onStatusRequested);
  }
  void _onStatusRequested(Map<PermissionGroup, PermissionStatus> statuses){
    final status = statuses[PermissionGroup.camera];
    _updateStatus(status);
  }


  void getImage() async{
    _askPermission();
    if (_status== PermissionStatus.granted) {
      var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _sampleImage = tempImage;
      });
      // continue with the image ...
    }
  }
  void uploadStatusImage() async{
    if(validateAndSave()){
      final StorageReference postImageRef = FirebaseStorage.instance.ref().child('Post Images');
      var timeKey = new DateTime.now();
      final StorageUploadTask uploadTask = postImageRef.child(timeKey.toString()+".jpg").putFile(_sampleImage);
      var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      url=imageUrl.toString();
      goToHomePage();
      saveToDatabase(url);
    }
  }

  bool validateAndSave(){
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    else
      return false;
  }
  void inputData() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.email;
    setState(() {
      mail = uid;
    });
  }

  void saveToDatabase(url) async{

    var dbTimeKey = new DateTime.now();
    var formatDate = new DateFormat('MMM d,yyyy');
    var formatTime = new DateFormat('EEEE,hh:mm aaa');
    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);
    final FirebaseUser user = await auth.currentUser();
    final uid = user.email;
    setState(() {
      mail = uid;
    });
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    var data = {
      'uid':mail,
      'image':url,
      'description':_myValue,
      'date':date,
      'time':time,
    };
    ref.child('Posts').push().set(data);
  }

  void goToHomePage(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=>(HomePage()))
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Upload Image'),
      ),
      body: Center(
        child: _sampleImage == null ? Text('Select an Image'): enableUpload(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Add Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget enableUpload(){
    return Container(
      child: SingleChildScrollView(
        child: new Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Image.file(_sampleImage, height: 310.0,width: 620.0,),
              SizedBox(height: 15.0,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description'
                ),
                validator: (value)=>(value.isEmpty ? 'Blog description is required' : null),
                onSaved: (value) => (_myValue=value),
              ),
              SizedBox(height: 15.0,),
              RaisedButton(
                elevation: 10.0,
                child: Text('Add new Post'),
                textColor: Colors.white,
                color: Colors.teal,
                onPressed: uploadStatusImage,
              ),
            ],
          ),
        ),
      ),
    );
  }

}
