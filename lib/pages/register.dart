import 'package:flutter/material.dart';
import 'package:chatbot_frontend/model/profile.dart';
import 'package:chatbot_frontend/pages/login.dart';
import 'dart:html';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
// import 'package:email_validator/email_validator.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  // const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  String created = "";
  String modified = "";
  bool is_admin = true;
  bool is_deleted = false;
  final formKey = GlobalKey<FormState>();
  // Profile profile = Profile();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  var _isObscured;

  RegExp pass_valid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  bool validatePassword(String pass) {
    String password = pass.trim();
    if (pass_valid.hasMatch(password)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _isObscured = true;
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("สร้างบัญชีผู้ใช้"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   "Email",
                  //   style: TextStyle(fontSize: 20),
                  // ),
                  TextFormField(
                      controller: name,
                      validator:
                          RequiredValidator(errorText: 'กรุณากรอกชื่อ-นามสกุล'),
                      // obscureText: true,
                      decoration: InputDecoration(
                          labelText: 'Name', border: OutlineInputBorder())),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                      controller: email,
                      validator:
                          // RequiredValidator(errorText: 'กรุณากรอกอีเมล์'),
                          MultiValidator([
                        RequiredValidator(errorText: 'กรุณากรอกอีเมล์'),
                        EmailValidator(errorText: 'กรุณากรอกอีเมล์ให้ถูกต้อง')
                      ]),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: 'Email', border: OutlineInputBorder())),
                  SizedBox(
                    height: 15,
                  ),
                  // Text(
                  //   "Password",
                  //   style: TextStyle(fontSize: 20),
                  // ),
                  TextFormField(
                      controller: password,
                      validator: (password) {
                        if (password!.isEmpty) {
                          RequiredValidator(errorText: 'กรุณากรอกรหัสผ่าน');
                        } else if (password.length < 6) {
                          return 'กรุณากรอกรหัสผ่านอย่างน้อย 6 ตัว';
                        } else {
                          bool result = validatePassword(password);
                          if (result) {
                            return null;
                          } else {
                            return "กรุณากรอกรหัสผ่านให้มีตัวเลข ตัวอักษรพิเศษ และตัวอักษรใหญ่";
                          }
                        }
                      },
                      obscureText: _isObscured,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            padding:
                                const EdgeInsetsDirectional.only(end: 12.0),
                            icon: _isObscured
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isObscured = !_isObscured;
                              });
                            },
                          ),
                          labelText: 'Password',
                          border: OutlineInputBorder())),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // formKey.currentState.save();
                        if (formKey.currentState!.validate()) {
                          // print("validate");
                          postTodo();
                          setState(() {
                            setUsername(email.text);
                            setPassword(password.text);
                            setPassword(name.text);
                            print(
                                "${email.text} and ${password.text} and ${name.text}");
                            // FirebaseAuth.instance
                            //     .createUserWithEmailAndPassword(
                            //         email: email.text, password: password.text);
                            // setStatus('Login successful');
                          });
                        }
                      },
                      child: Text(
                        "ลงทะเบียน",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    // ---------------------------------------------------------------------------------------------------------------------------------
    // return FutureBuilder(
    //     future: firebase,
    //     builder: (context, snapshot) {
    //       if (snapshot.hasError) {
    //         return Scaffold(
    //           appBar: AppBar(
    //             title: Text("Error"),
    //           ),
    //           body: Center(
    //             child: Text("${snapshot.error}"),
    //           ),
    //         );
    //       }
    //       if (snapshot.connectionState == ConnectionState.done) {
    //         return Scaffold(
    //           appBar: AppBar(
    //             title: Text("สร้างบัญชีผู้ใช้"),
    //           ),
    //           body: Container(
    //             child: Padding(
    //               padding: const EdgeInsets.all(20.0),
    //               child: Form(
    //                 key: formKey,
    //                 child: SingleChildScrollView(
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       // Text(
    //                       //   "Email",
    //                       //   style: TextStyle(fontSize: 20),
    //                       // ),
    //                       TextFormField(
    //                           controller: email,
    //                           validator:
    //                               // RequiredValidator(errorText: 'กรุณากรอกอีเมล์'),
    //                               MultiValidator([
    //                             RequiredValidator(errorText: 'กรุณากรอกอีเมล์'),
    //                             EmailValidator(
    //                                 errorText: 'กรุณากรอกอีเมล์ให้ถูกต้อง')
    //                           ]),
    //                           keyboardType: TextInputType.emailAddress,
    //                           decoration: InputDecoration(
    //                               labelText: 'Email',
    //                               border: OutlineInputBorder())),
    //                       SizedBox(
    //                         height: 15,
    //                       ),
    //                       // Text(
    //                       //   "Password",
    //                       //   style: TextStyle(fontSize: 20),
    //                       // ),
    //                       TextFormField(
    //                           controller: password,
    //                           validator: RequiredValidator(
    //                               errorText: 'กรุณากรอกรหัสผ่าน'),
    //                           obscureText: true,
    //                           decoration: InputDecoration(
    //                               labelText: 'Password',
    //                               border: OutlineInputBorder())),
    //                       SizedBox(
    //                         height: 15,
    //                       ),
    //                       SizedBox(
    //                         width: double.infinity,
    //                         child: ElevatedButton(
    //                           onPressed: () {
    //                             // formKey.currentState.save();
    //                             if (formKey.currentState!.validate()) {
    //                               // print("validate");
    //                               setState(() {
    //                                 setUsername(email.text);
    //                                 setPassword(password.text);
    //                                 // print("${email.text} and ${password.text}");
    //                                 FirebaseAuth.instance
    //                                     .createUserWithEmailAndPassword(
    //                                         email: email.text,
    //                                         password: password.text);
    //                                 // setStatus('Login successful');
    //                               });
    //                             }
    //                           },
    //                           child: Text(
    //                             "ลงทะเบียน",
    //                             style: TextStyle(fontSize: 20),
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ),
    //         );
    //       }
    //       return Scaffold(
    //         body: Center(
    //           child: CircularProgressIndicator(),
    //         ),
    //       );
    //     });
    //
  }

  Future<void> setUsername(textEmail) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('Email', textEmail);
  }

  Future<void> setPassword(textPassword) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('password', textPassword);
  }

  Future<void> setName(textName) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('name', textName);
  }

  Future postTodo() async {
    print("${email.text} or ${password.text}");
    var url = Uri.http('127.0.0.1:8000', '/api/CheckRegister');

    //ประเภทของ Data ที่เราจะส่งไป เป็นแบบ json
    //header ของ PO ST request

    Map<String, String> header = {"Content-type": "application/json"};
    //Data ที่จะส่ง
    //String jsondata = '{"title":"AAA", "detail": "BBB"}';
    // String jsondata = '{"title":"${email.text}", "detail":"${password.text}"}';
    String jsondata =
        // '{"email": "${email.text}","password": "${password.text}"}';
        '{"email": "${email.text}"}';

    //เป็นการ Response ค่าแบบ POST
    var response = await http.post(url, headers: header, body: jsondata);
    String CheckUser = response.body;
    if (CheckUser == '{"is_login":true}') {
      print('------result-------');
      print(response.body);
      print('success');
      normalDialog(context, 'อีเมลนี้มีผู้ใช้งานแล้ว');
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => RegisterPage()));
    } else {
      // print('fucking good');
      // print(response.body);
      var url = Uri.http('127.0.0.1:8000', '/api/post-user/');
      Map<String, String> header = {"Content-type": "application/json"};
      String jsondata =
          '{"name": "${name.text}","email": "${email.text}","password": "${password.text}"}';
      var response = await http.post(url, headers: header, body: jsondata);
      print('------result-------');
      print(response.body);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
      // normalDialog(context, 'กรุณากรอกอีเมล์หรือรหัสผ่านให้ถูกต้อง');
    }
  }

  Future<Null> normalDialog(BuildContext context, String message) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(message),
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
