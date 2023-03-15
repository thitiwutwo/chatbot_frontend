//page for chat list
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:chatbot_frontend/pages/user/chat.dart';
class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);
  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 50,
        margin: const EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatbotPage()));
          },
          child: const Center(
            child: Text('สร้างข้อความใหม่'),
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text("ข้อความ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right:20),
            child: IconButton(
              icon:const Icon(Icons.account_circle_rounded,color: Colors.black, size: 40,), onPressed: () {  },
            ),
          )
        ],
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'ค้นหา',
                icon: Icon(Icons.search),
              ),
              
            ),
            
          ]
          
        ),
    );
    
  }
  Widget listData() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 80.0),
      child: ListView.builder(
        itemCount: 20,
        itemBuilder: ((context, index) {
          return Card (
            child: ListTile(
                leading: Icon(Icons.book, color: Color.fromARGB(255, 140, 140, 255),),
                title: Text("Title chat",),
                subtitle: Text('Here is a second line'),
                trailing: Icon(Icons.more_vert),
              ));
        }),
      ),
    );
  }
}