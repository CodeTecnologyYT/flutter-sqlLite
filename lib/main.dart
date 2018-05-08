import 'package:database_intro/models/User.dart';
import 'package:database_intro/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

List _user;
void main() async{
  var db = new DatabaseHelper();


  //Add user
  int saveUser = await db.saveUser(new User("Ana","anita"));
  print("User saverd $saveUser");
  _user = await db.getAllUsers();

  for(int i=0;i<_user.length;i++){
    User user=User.map(_user[i]);
    print("Username: ${user.username}");
  }

  runApp(new MaterialApp(
    title: "database",
    home: new Home(),
  ));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Database"),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
      ),
    );
  }
}
