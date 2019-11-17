import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'PhotoUpload.dart';
import 'Posts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {

  HomePage
      ({
    this.auth,
    this.onSignedOut,
});
  final AuthImplementation auth;
  final VoidCallback onSignedOut;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Posts> postsList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseReference ref = FirebaseDatabase.instance.reference().child('Posts');
    ref.once().then((DataSnapshot snap){
      var KEYS = snap.value.keys;
      var DATA = snap.value;
      postsList.clear();
      for(var individualKey in KEYS)
        {
          Posts posts = new Posts(
            DATA[individualKey]['uid'],
            DATA[individualKey]['image'],
            DATA[individualKey]['description'],
            DATA[individualKey]['date'],
            DATA[individualKey]['time'],
          );
          postsList.add(posts);
        }
      setState(() {
        print('Length : $postsList.length');
      });
    });
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void _logoutUser() async{
    try{
      await _auth.signOut();
      widget.onSignedOut();
    }
    catch(e){
      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Center(child: Text('Home',)),
      ),
      body: Container(
        child: postsList.length ==0 ? Text("No blog post availbale") : ListView.builder(
          itemCount: postsList.length,
          itemBuilder: (_,index){
            return postsUI(postsList[index].mail,postsList[index].image,postsList[index].description,postsList[index].date,postsList[index].time);
          },
        ),
      ),
      bottomNavigationBar: new BottomAppBar(
        color: Colors.teal,
        child: Container(
          margin: EdgeInsets.only(left: 70.0,right: 70.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.power_settings_new),
                  iconSize: 50,
                  color: Colors.white,
                  onPressed: _logoutUser,
              ),
              IconButton(
                  icon: Icon(Icons.add_a_photo),
                  iconSize: 40,
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=>(UploadPhotoPage()))
                    );
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget postsUI(String mail,String image,String description,String date,String time){
    return new Card(
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),
      child: Container(
        padding: EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  mail,
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,
                ),
                Text(
                  date,
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,
                ),
                Text(
                  time,
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(height: 10.0,),
            Image.network(image,fit:BoxFit.cover),
            SizedBox(height: 10.0,),
            Text(
              description,
              style: Theme.of(context).textTheme.subhead,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
