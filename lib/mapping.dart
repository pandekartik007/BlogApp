import 'package:flutter/material.dart';
import 'Login.dart';
import 'HomePage.dart';
import 'Authentication.dart';

class MappingPage extends StatefulWidget {
  final AuthImplementation auth;
  MappingPage
      ({
    this.auth,
});
  @override
  _MappingPageState createState() => _MappingPageState();
}

enum AuthStatus
{
  notSignedIn,
  signedIn,
}
class _MappingPageState extends State<MappingPage> {
  AuthStatus _authStatus = AuthStatus.notSignedIn;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.auth.getCurrentUser().then((firebaseUserId)
    {
      setState(() {
        _authStatus = firebaseUserId==null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }
  void _signedIn()
  {
    setState(() {
      _authStatus  =AuthStatus.signedIn;
    });
  }
  void _signOut()
  {
    setState(() {
      _authStatus  =AuthStatus.notSignedIn;
    });
  }
  @override
  Widget build(BuildContext context) {
    switch(_authStatus)
    {
      case AuthStatus.notSignedIn:
        return LoginRegister(
          auth: widget.auth,
          onSignedIn: _signedIn,
        );
      case AuthStatus.signedIn:
        return HomePage(
          auth: widget.auth,
          onSignedOut: _signOut,
        );
    }
    return null;
  }
}
