import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class ChatMessage {
  String text;
  String sender;
  bool isUser;
  DateTime time;
  String file_url;
  ChatMessage({required this.text, required this.sender, this.isUser = false, required this.time, required this.file_url});
}

class ChatbotPage extends StatefulWidget {
  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}


class _ChatbotPageState extends State<ChatbotPage> {
  List<ChatMessage> messages = [];
  void initState() {
    // TODO: implement initState
    super.initState();
    getChatHistory();
    
  }
  
  List faq = ['ทำอะไรได้บ้าง', 'ขอเอกสารลา', 'ขอเอกสารลาออก', 'ขอเอกสารเบิกเงิน', 'ขอเอกสารทำงานล่วงเวลา'];
  TextEditingController _controller = TextEditingController();
  final regex_image = RegExp(r'\.(jpeg|jpg|png|gif)$', caseSensitive: false);
  bool isLoading = false;
  ButtonStyle styleBtn = ElevatedButton.styleFrom(
    primary: Color.fromARGB(255,0, 154, 115),
    padding: EdgeInsets.all(17.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black, // <-- SEE HERE
        ),
        centerTitle: true,
        elevation: 0,
        title: Text('ข้อความ', style: TextStyle(color: Colors.black, fontSize: 30.0, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              'วันนี้เวลา '+DateFormat('HH:mm').format(DateTime.now()),
              style: TextStyle(fontSize: 12.0,color: Color.fromARGB(255, 139, 139, 139)),
            ),
          ),
          Flexible(
            child: ListView.builder(
              // reverse: true,
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                final message = messages[index];
                final message_before = messages[index == 0 ? 0: index-1];
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        if (!message.isUser && message_before.isUser)
                          CircleAvatar(
                            radius: 20.0,
                            backgroundImage: NetworkImage('https://img.freepik.com/premium-vector/chatbot-robot-concept_441769-308.jpg?w=740'),
                          ),
                        if(!message_before.isUser)
                          SizedBox(width: 40.0),
                        SizedBox(width: 10.0),
                        Flexible(
                          fit: FlexFit.loose,
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text(
                                    DateFormat('yyyy-MM-dd HH:mm').format(message.time),
                                  ),
                                  content: Text(message.text),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: message.isUser ? Color.fromARGB(255,0, 154, 115) : Colors.grey[300],
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              padding:
                                  EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                              child: 
                                regex_image.hasMatch(message.file_url) ?
                                InkWell(
                                borderRadius: BorderRadius.circular(20.0),
                                onTap: () { showDialog(
                                    context: context,
                                    builder: (_) => Dialog(
                                      child: Container(
                                        width: 180,
                                        height: 300,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(message.file_url),
                                            fit: BoxFit.contain
                                          )
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: message.isUser
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
        
                                    SizedBox(height: 3.0),
                                    
                                    Image.network(message.file_url, width: 150, height: 180,),
                                    
                                  ],
                                ),
                              ):
                                InkWell(
                                borderRadius: BorderRadius.circular(20.0),
                                onTap: message.file_url == '' ? () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: Text(
                                        DateFormat('yyyy-MM-dd HH:mm').format(message.time),
                                      ),
                                      content: Text(message.text),
                                    ),
                                  ); 
                                }: () => {
                                    if(!regex_image.hasMatch(message.file_url)){
                                      launch(message.file_url)
                                    }
                                  },
                                child: Column(
                                  crossAxisAlignment: message.isUser
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    // if (!message.isUser)
                                    //   Text(
                                    //     message.sender,
                                    //     style: TextStyle(
                                    //       color: Colors.grey[600],
                                    //       fontWeight: FontWeight.bold,
                                    //     ),
                                    //   ),
                                    SizedBox(height: 3.0),
                                    
                                    Text(
                                      message.text,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: message.isUser? Colors.white : Colors.black,
                                        decoration: message.file_url != '' ? TextDecoration.underline : null
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(width: 2.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child:Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  for(int i = 0; i < faq.length; i++)
                  Padding(
                    padding: EdgeInsets.only(left: i == 0 ? 0:5.0),
                    child: ElevatedButton(onPressed: () => {
                      _controller.text = faq[i],
                      sendMessage()
                    }, 
                      child: Text(faq[i], style: TextStyle(fontSize: 16)),
                      style: styleBtn),
                  ),

                  // ElevatedButton(onPressed: () {}, 
                  //   child: Text('ขอเอกสารลา', style: TextStyle(fontSize: 16)),
                  //   style: styleBtn),
                  // SizedBox(width: 5.0),
                  
                  
                ],
              ),
            ),
          ),
          SizedBox(height: 1.0,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 240, 240, 240),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: Offset(0, 3),
                  ),  
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'พิมพ์ข้อความ...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(20.0),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (text) => sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, size: 28,),
                    color: Color.fromARGB(255,0, 154, 115),
                    onPressed: () => sendMessage(),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.0,),
        ],
      ),
    );
  }

  Future getChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final int? channel_id = prefs.getInt('channel_id');
    try{
      final Dio dio = Dio();
      final baseUrl = dotenv.env['Url'];
      final response = await dio.get('$baseUrl/api/get-chat/${channel_id}');
      if(response.statusCode == 200){
        List<dynamic> dataJson = response.data;
        var chats = dataJson;
        for(var message in chats){
          setState(() {
            messages.add(
              ChatMessage(
                text: message['text'],
                sender: message['sender_id'] == 0 ? 'bot' : 'user',
                isUser: message['is_user'],
                time: DateTime.parse(message['datetime']),
                file_url: message['file_url'] ?? '',
              ),
            );
            
          });
        }
      }else{
          throw Exception('Failed to fetch data');
        }
    }catch(e){
      print(e.toString());
    }
  }

  Future getFile(var intent) async{
    try{
      final Dio dio = Dio();
      final baseUrl = dotenv.env['Url'];
      final response = await dio.get('$baseUrl/api/get-file/$intent');
      // var result = utf8.decode(response.bodyBytes);
      print(response);
      if(response.statusCode == 200){
        
        return response.data;
      }else{
        throw Exception('Failed to fetch data');
      }
    }catch(e){
      print(e.toString());
    }
  }

  void addChannel(String text) async{
    final Dio dio = Dio();
    final baseUrl = dotenv.env['Url'];
    final response = await dio.post('$baseUrl/api/create-channel', data: {
      "name" : text,
      "sender_id": 1,
    });
    if(response.statusCode == 200){
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('channel_id', response.data['id']);
      addMessage(text, DateTime.now(), is_user: true);
    }
    
  }

  void addMessage(String text, DateTime date,{String file_url = '' , bool is_user = false}) async{
    final prefs = await SharedPreferences.getInstance();
    final int? channel_id = prefs.getInt('channel_id');
    final Dio dio = Dio();
    final baseUrl = dotenv.env['Url'];
    final response = await dio.post('$baseUrl/api/create-chat', data: {
        "text" : text,
        "sender_id" : 1,
        "is_user" : is_user,
        "channel" : channel_id,
        "file_url" : file_url
    });
    
    print(response.data);
  }

  void sendMessage() async {
    final prefs = await SharedPreferences.getInstance();
    final text = _controller.text;
    if (text.isEmpty) {
      return;
    }
    if(messages.length == 0 && (prefs.getInt('channel_id') == null)){
      addChannel(text);
    }
    setState(() {
      messages.add(
        ChatMessage(
          text: text,
          sender: 'Me',
          isUser: true,
          time: DateTime.now(),
          file_url: '',
        ),
      );
      addMessage(text, DateTime.now(), is_user: true);
      isLoading = true;
    });
    _controller.clear();
    try {
      // final query = DetectIntentRequest(
      //     queryInput: QueryInput(text: TextInput(text: text)),
      //     queryParams:
      //         QueryParameters(timeZone: 'Asia/Bangkok', locale: 'th'));
      AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/credentials/admin_credentials.json")
            .build();
      Dialogflow dialogflow =
          Dialogflow(authGoogle: authGoogle, language: Language.thai);
      final response = await dialogflow.detectIntent(text);
      print(response.queryResult.intent.displayName);
      final message = response.queryResult.fulfillmentText;

      final file = await getFile(response.queryResult.intent.displayName);
      setState(() {
        messages.add(
          ChatMessage(
            text: message,
            sender: 'Bot',
            time: DateTime.now(),
            file_url: ''
          ),
          
        );
        addMessage(message, DateTime.now());
        isLoading = false;
      });
      if(file != null) {
        setState(() {
          print('add file');
          messages.add(
            ChatMessage(
              text: file["name"],
              sender: 'Bot',
              time: DateTime.now(),
              file_url: file['file']
            ),
          );
          isLoading = false;
          addMessage(file["name"], DateTime.now(),file_url: file['file']);
        });
      }
        
        
      
      
      // setState(() {
      //   messages.add(
      //     ChatMessage(
      //       text: message,
      //       sender: 'Bot',
      //       time: DateTime.now(),
      //     ),
      //   );
      //   isLoading = false;
      // });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }
}