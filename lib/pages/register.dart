import 'package:flutter/material.dart';
import 'package:chatbot_frontend/model/profile.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
                      validator:
                          RequiredValidator(errorText: 'กรุณากรอกรหัสผ่าน'),
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: 'Password', border: OutlineInputBorder())),
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
    //http://10.80.25.48:8000/api/post-todolist
    print("${email.text} or ${password.text}");
    final Dio dio = Dio();
    final baseUrl = dotenv.env['Url'];
    final response = await dio.post('$baseUrl/api/post-user/', data:{
      "name" : name.text,
      "email": email.text,
      "password": password.text,
      "is_admin": false
    });
    print(response);
    print(response.statusCode);
    if (response.statusCode == 200) {
      Navigator.pop(context);
    }
  }
}
