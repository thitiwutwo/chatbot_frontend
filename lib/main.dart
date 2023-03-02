import 'package:flutter/material.dart';
import 'package:chatbot_frontend/pages/user/chat_list.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'main',
      theme: new ThemeData(
        fontFamily: 'Inter',
        primarySwatch: Colors.deepOrange,
      ),
      debugShowCheckedModeBanner: false,
      // ตัวอย่าง  สำหรับเทสหน้าจอของตัวเอง
      home: ChatList(), //เอาชื่อคลาสมาใส่
    );
  }
}