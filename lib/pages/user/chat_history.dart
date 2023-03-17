import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chatbot_frontend/pages/user/chat.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class ChatHistory extends StatefulWidget {
  @override
  _ChatHistoryState createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  // You can customize the data for your chat list here
  
  List chatHistory = [];
  void initState() {
    // TODO: implement initState
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: 50,
          margin: const EdgeInsets.only(top:10, left:10, right:10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(255,237, 238, 240),
              onPrimary: Colors.black,
              shadowColor: Colors.black,
              elevation: 10.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            ),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('channel_id');
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatbotPage()));
            },
            child: const Center(
              child: Text('สร้างข้อความใหม่', style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: Text("ข้อความ",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right:20),
            child: IconButton(
              icon:const Icon(Icons.account_circle_rounded,color: Colors.black, size: 40,), onPressed: () {  },
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.grey[200],
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.search),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "ค้นหา",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom:60.0),
              child: ListView.builder(
                itemCount: chatHistory.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: Key(chatHistory[index]['id'].toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    onDismissed: (direction) {
                      setState(() async {
                        await removeChannel(chatHistory[index]['id']);
                        chatHistory.removeAt(index);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1.0,
                              color: Color.fromARGB(255, 224, 224, 224),
                            ),
                          ),
                        ),
                        child: ListTile(
                          title: Text(chatHistory[index]['name']),
                          trailing: Text(DateFormat('HH:mm').format(DateTime.parse(chatHistory[index]['modified']))),
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setInt('channel_id', chatHistory[index]['id']);
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatbotPage()));
                            // Handle chat tile press here
                          },
                        ),
                      ),
                    ), 
                  );
                },
              ),
            ),
          ),
          
        ],
      ),
    );
  }
  Future getList() async{
    try{
      final Dio dio = Dio();
      final baseUrl = dotenv.env['Url'];
      final response = await dio.get('$baseUrl/api/get-channel/');
      
      if(response.statusCode == 200){
        List<dynamic> dataJson = response.data;
        setState(() {
          chatHistory = dataJson;
        });
      }else{
        throw Exception('Failed to fetch data');
      }
    }catch(e){
      print(e.toString());
    }
  }

  Future removeChannel(int channel_id) async{
    try{
      final Dio dio = Dio();
      final baseUrl = dotenv.env['Url'];
      final response = await dio.put('$baseUrl/api/delete-channel/$channel_id');
      if(response.statusCode == 200){
        setState(() {
          getList();
        });
      }else{
        throw Exception('Failed to fetch data');
      }
    }catch(e){
      print(e.toString());
    }
  }
}
