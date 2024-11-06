import 'dart:async';
import 'package:flutter/material.dart';
import 'package:recipes/login/login_page.dart';
import 'package:recipes/home/bottom_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: checkAuthentication(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final isAuthenticated = snapshot.data as bool;
            return isAuthenticated ? BottomNavigation(selectedIndex: 0) : LoginPage();
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

 Future<bool> checkAuthentication() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('authToken56');
    return authToken != null;
  }
}




