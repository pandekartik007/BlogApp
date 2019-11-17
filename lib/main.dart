import 'package:flutter/material.dart';
import 'package:blog/Login.dart';
import 'mapping.dart';
import 'HomePage.dart';
import 'Authentication.dart';

void main() => runApp(BlogApp());

class BlogApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Blog App",
      theme: new ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: MappingPage(auth: Auth()),
    );
  }
}
