import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'dialogBox.dart';

class LoginRegister extends StatefulWidget {
  LoginRegister
      ({
    this.auth,
    this.onSignedIn,
});
  final AuthImplementation auth;
  final VoidCallback onSignedIn;
  @override
  _LoginRegisterState createState() => _LoginRegisterState();
}
enum FormType {
  login,
  register
}
class _LoginRegisterState extends State<LoginRegister> {

  DialogBox dialogBox = new DialogBox();

  final formKey = new GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email="";
  String _password="";
  bool validateAndSave(){
    final form = formKey.currentState;
    if(form.validate())
      {
        form.save();
        return true;
      }
    else
      return false;
  }
  void moveToRegister(){
    formKey.currentState.reset();
    setState(() {
      _formType=FormType.register;
    });
  }

  void validateAndSubmit() async{
    if(validateAndSave()){
      try{
        if(_formType==FormType.login){
          String userId = await widget.auth.signIn(_email, _password);
          //dialogBox.information(context, "Congratulations","You are logged in successfully");
          print("login user id = " + userId);
        }
        else{
          String userId = await widget.auth.signUp(_email, _password);
          //dialogBox.information(context, "Congratulations ","Your Account has been created successfully");
          print("Register user id = " + userId);
        }
        widget.onSignedIn();
      }
      catch(e){
        dialogBox.information(context, "Error",e.toString());
        print("Error =  " + e.toString());
      }
    }
  }

  void moveToLogin(){
    formKey.currentState.reset();
    setState(() {
      _formType=FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Blog App"),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    new Container(
                      height: 210.0,
                        width: 210.0,
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.circular(200.0),
                      ),
                      child: Image.asset('images/a.png'),
                    )
                  ],
              ),
                Form(
                  key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        new TextFormField(
                          decoration: new InputDecoration(labelText: 'Email'),
                          validator: (value)=>(value.isEmpty ? 'Email is required' : null),
                          onSaved: (value)=>(_email=value),
                        ),
                        SizedBox(height:10.0),
                        TextFormField(
                          decoration: new InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (value)=>(value.isEmpty ? 'Password is required' : null),
                          onSaved: (value)=>(_password=value),
                        ),
                        SizedBox(height:10.0),
                        new RaisedButton(
                          child: Text(_formType==FormType.login ? 'Login' : 'Create Account',
                            style: new TextStyle(fontSize: 20.0),
                          ),
                          textColor: Colors.white,
                          color: Colors.teal,
                          onPressed: validateAndSubmit,
                        ),
                        new FlatButton(
                          child: Text(_formType==FormType.login ? 'Not have an account? Sign up': 'Already have an account? Login',style: TextStyle(fontSize: 14.0),),
                          color: Colors.cyan,
                          onPressed: _formType==FormType.login ? moveToRegister : moveToLogin,
                        ),
                      ],
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  /*List<Widget> createInputs()
  {
    return
      [
        SizedBox(height:10.0),
        logo(),
        SizedBox(height: 20.0,),
        TextFormField(
          decoration: new InputDecoration(labelText: 'Email'),
        ),
        SizedBox(height:10.0),
        TextFormField(
          decoration: new InputDecoration(labelText: 'Password'),
        ),
        SizedBox(height:10.0),

      ];
  }
  Widget logo()
  {
    return Hero(
      tag: 'hero',
        child: new CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 110.0,
          child: Image.asset('images/a.png'),
        )
    );
  }
  List<Widget> createButtons()
  {
  if(_formType == FormType.login){
    return
      [
        new RaisedButton(
          child: Text('Login',
          style: new TextStyle(fontSize: 20.0),
          ),
          textColor: Colors.white,
          color: Colors.teal,
          onPressed: validateAndSave,
        ),
        new FlatButton(
          child: Text('Not have an account? Sign up',style: TextStyle(fontSize: 14.0),),
          onPressed: moveToRegister,
        )
      ];
      }
  else
    {
      return
        [
          new RaisedButton(
            child: Text('Login',
              style: new TextStyle(fontSize: 20.0),
            ),
            textColor: Colors.white,
            color: Colors.teal,
            onPressed: validateAndSave,
          ),
          new FlatButton(
            child: Text('Not have an account? Sign up',style: TextStyle(fontSize: 14.0),),
            onPressed: moveToRegister,
          )
        ];
    }
  }*/
}

