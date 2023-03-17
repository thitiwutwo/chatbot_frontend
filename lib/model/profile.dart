import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  // const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? email = '';
  String? password = '';
  String? name = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEmail();
    getPassword();
    getName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Text("${email}"),
        Text("${password}"),
        Text("${name}"),
      ]),
    );
  }

  Future<void> getEmail() async {
    var pref = await SharedPreferences.getInstance();
    var myStr = pref.getString('Email');
    setState(() {
      email = myStr;
    });
  }

  Future<void> getPassword() async {
    var pref = await SharedPreferences.getInstance();
    var myStr = pref.getString('password');
    setState(() {
      password = myStr;
    });
  }

  Future<void> getName() async {
    var pref = await SharedPreferences.getInstance();
    var myStr = pref.getString('name');
    setState(() {
      name = myStr;
    });
  }
}
