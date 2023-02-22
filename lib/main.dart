import 'package:flutter/material.dart';
// ตัวอย่างการ import สำหรับเทสหน้าจอของตัวเอง
// import 'package:chatbot_frontend/pages/user/chat.dart'; // หน้า view ของตัวเอง
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
        primarySwatch: Colors.deepOrange,
      ),
      debugShowCheckedModeBanner: false,
      // ตัวอย่าง  สำหรับเทสหน้าจอของตัวเอง
      // home: ChatPage(title: ''), //เอาชื่อคลาสมาใส่
    );
  }
}