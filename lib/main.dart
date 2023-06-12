import 'package:flutter/material.dart';
import 'package:j_chat/helper/authenticate.dart';
import 'package:j_chat/helper/helperfunctions.dart';
import 'package:j_chat/views/chatRoomsScreen.dart';
import 'package:j_chat/views/signin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool userIsLoggedIn ;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState()async{
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value;

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userIsLoggedIn !=null ? userIsLoggedIn? ChatRoom(): Authenticate() : Authenticate() ,
    );
  }
}

class IamBlank extends StatefulWidget {
  @override
  _IamBlankState createState() => _IamBlankState();
}

class _IamBlankState extends State<IamBlank> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}



