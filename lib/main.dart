import 'package:flutter/material.dart';
// ตัวอย่างการ import สำหรับเทสหน้าจอของตัวเอง
import 'package:chatbot_frontend/pages/user/chat_list.dart'; // หน้า view ของตัวเอง
import 'package:chatbot_frontend/pages/user/test_chat_list.dart';
import 'package:chatbot_frontend/pages/user/chat.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Dialogflow Flutter',
      theme: new ThemeData(
        fontFamily: 'Inter',
        primaryColor: Color.fromARGB(255,0, 154, 115),
      ),
      debugShowCheckedModeBanner: false,
      // ตัวอย่าง  สำหรับเทสหน้าจอของตัวเอง
      home: ChatbotPage(), //เอาชื่อคลาสมาใส่
    );
  }
}