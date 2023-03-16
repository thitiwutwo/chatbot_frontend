import 'package:chatbot_frontend/pages/register.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chatbot_frontend/model/profile.dart';
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
import 'package:dio/dio.dart';

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
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("เข้าสู่ระบบ"),
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
                          getData();
                          setState(() {
                            setUsername(email.text);
                            setPassword(password.text);
                            print("${email.text} and ${password.text}");
                            // FirebaseAuth.instance
                            //     .createUserWithEmailAndPassword(
                            //         email: email.text, password: password.text);
                            // setStatus('Login successful');
                          });
                        }
                      },
                      child: Text(
                        "เข้าสู่ระบบ",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()));
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
    var url = Uri.http('127.0.0.1:8000', '/api/login');

    //ประเภทของ Data ที่เราจะส่งไป เป็นแบบ json
    //header ของ PO ST request

    Map<String, String> header = {"Content-type": "application/json"};
    //Data ที่จะส่ง
    //String jsondata = '{"title":"AAA", "detail": "BBB"}';
    // String jsondata = '{"title":"${email.text}", "detail":"${password.text}"}';
    String jsondata =
        // '{"email": "${email.text}","password": "${password.text}"}';
        '{"email": "${email.text}","password": "${password.text}"}';

    //เป็นการ Response ค่าแบบ POST
    var response = await http.post(url, headers: header, body: jsondata);
    String CheckUser = response.body;
    if (CheckUser == '{"is_login":true}') {
      print('------result-------');
      print(response.body);
      print('success');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => RegisterPage()));
    } else {
      print('fucking good');
      normalDialog(context, 'กรุณากรอกอีเมล์หรือรหัสผ่านให้ถูกต้อง');
    }
    // print("getData");
    // try {
    //   final Dio dio = Dio();
    //   final String baseUrl = 'http://127.0.0.1:8000/api/';
    //   final response = await dio.get('$baseUrl/login');
    //   print("try");
    //   if (response.statusCode == 200) {
    //     List<dynamic> dataJson = response.data;
    //     setState(() {
    //       // data = dataJson.map((json) => ChartData.fromJson(json)).toList();
    //     });
    //     print("if");
    //   } else {
    //     print("else");
    //     throw Exception('Failed to fetch data');
    //   }
    // } catch (e) {
    //   print("catch");
    //   print(e.toString());
    // }
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
