import 'package:flutter/material.dart';
// ตัวอย่างการ import สำหรับเทสหน้าจอของตัวเอง
import 'package:chatbot_frontend/pages/user/chat_list.dart'; // หน้า view ของตัวเอง
// import 'package:chatbot_frontend/pages/user/test_chat_list.dart';
import 'package:chatbot_frontend/pages/user/chat.dart';
import 'package:chatbot_frontend/pages/user/chat_history.dart';
import 'package:chatbot_frontend/test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'main',
      theme: new ThemeData(
        fontFamily: 'Inter',
        primaryColor: Color.fromARGB(255,0, 154, 115),
      ),
      debugShowCheckedModeBanner: false,
      // ตัวอย่าง  สำหรับเทสหน้าจอของตัวเอง
      home: ChatHistory(), //เอาชื่อคลาสมาใส่
    );
  }
}