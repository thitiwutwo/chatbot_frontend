import 'package:chatbot_frontend/pages/register.dart';
import 'package:chatbot_frontend/pages/register.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chatbot_frontend/model/profile.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:chatbot_frontend/pages/user/chat_history.dart';


class LoginPage extends StatefulWidget {
  // const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  // TextEditingController name = TextEditingController();
  // String created = "";
  // String modified = "";
  // bool is_admin = true;
  // bool is_deleted = false;
  final formKey = GlobalKey<FormState>();
  // Profile profile = Profile();
  var _isObscured;

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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 251, 252, 252),
              Color.fromARGB(255, 19, 175, 136)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text(
                  //   "Email",
                  //   style: TextStyle(fontSize: 20),
                  // ),
                  Center(
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 60,
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
                          filled: true,
                          fillColor: Color.fromARGB(255, 255, 255, 255),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 3,
                                color: Color.fromARGB(
                                    255, 255, 255, 255)), //<-- SEE HERE
                          ),
                          labelText: 'Email',
                          border: OutlineInputBorder())),
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
                      obscureText: _isObscured,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(255, 255, 255, 255),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 3,
                                color: Color.fromARGB(
                                    255, 255, 255, 255)), //<-- SEE HERE
                          ),
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
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        primary: Color.fromARGB(255, 255, 255, 255),
                      ),
                      onPressed: () {
                        // formKey.currentState.save();
                        if (formKey.currentState!.validate()) {
                          // print("validate");
                          getData();
                          setState(() {
                            setUsername(email.text);
                            setPassword(password.text);
                            print("${email.text} and ${password.text}");
                           
                          });
                        }
                      },
                      child: Text(
                        "เข้าสู่ระบบ",
                        style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 19, 175, 136)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(30.0),
                  //       ),
                  //       primary: Color.fromARGB(255, 255, 255, 255),
                  //     ),
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => RegisterPage()));
                  //     },
                  //     child: Text(
                  //       "ลงทะเบียน",
                  //       style: TextStyle(
                  //           fontSize: 20,
                  //           color: Color.fromARGB(255, 19, 175, 136)),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> setUsername(textUsername) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('username', textUsername);
  }

  Future<void> setPassword(textPassword) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('password', textPassword);
  }

  Future<void> getData() async {
    print("${email.text} or ${password.text}");
    // var url = Uri.http('127.0.0.1:8000', '/api/login');
    final Dio dio = Dio();
    final baseUrl = dotenv.env['Url'];
    final response = await dio.post('$baseUrl/api/login', data:{
      "email": email.text,
      "password": password.text
    });
    //ประเภทของ Data ที่เราจะส่งไป เป็นแบบ json
    //header ของ PO ST request
    if (response.data['is_login']){
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      int user_id = response.data['id'];
      prefs.setInt('user_id', user_id);
      print('success');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ChatHistory()));
    } else {
      normalDialog(context, 'กรุณากรอกอีเมล์หรือรหัสผ่านให้ถูกต้อง');
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
