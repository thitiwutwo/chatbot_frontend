import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:cool_alert/cool_alert.dart';

class AddPage extends StatefulWidget {
  //const AddPage({ Key? key }) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController question = TextEditingController();
  TextEditingController answer = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AddPage"), actions: [
        PopupMenuButton(itemBuilder: (context) {
          return [
            PopupMenuItem<int>(
              value: 0,
              child: Row(
                children: <Widget>[
                  Icon(Icons.add_photo_alternate,
                      size: 25, color: Colors.black),
                  Text('Add Image'),
                ],
              ),
            ),
            PopupMenuItem<int>(
              value: 1,
              child: Row(
                children: <Widget>[
                  Icon(Icons.picture_as_pdf, size: 25, color: Colors.black),
                  Text('Add File'),
                ],
              ),
            ),
          ];
        }, onSelected: (value) {
          if (value == 0) {
            print("add file");
          } else if (value == 1) {
            print("add image");
          }
        }),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            SizedBox(height: 20),
            TextField(
                minLines: 2,
                maxLines: 4,
                controller: question,
                decoration: InputDecoration(
                    labelText: 'คำถาม', border: OutlineInputBorder())),
            SizedBox(height: 20),
            TextField(
                minLines: 4,
                maxLines: 8,
                controller: answer,
                decoration: InputDecoration(
                    labelText: 'คำตอบ', border: OutlineInputBorder())),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () {
                  if(question.text != "" && answer.text != "") {
                  CoolAlert.show(
                    context: context,
                    type: CoolAlertType.success,
                    text: "Your add question success!",
                  );
                  }
                  setState(() {
                    question.clear(); //เคลียร์ข้อมูลหลังจากโพสต์
                    answer.clear(); //เคลียร์ข้อมูลหลังจากโพสต์
                  });
                },
                child: Text("Save"),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.fromLTRB(50, 20, 50, 20)),
                    textStyle:
                        MaterialStateProperty.all(TextStyle(fontSize: 30))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
