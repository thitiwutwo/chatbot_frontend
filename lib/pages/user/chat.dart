import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

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
  List<ChatMessage> messages = [
          // ChatMessage(
          //   text: 'สวัสดี',
          //   sender: 'Bot',
            
          //   time: DateTime.now(),
          // ),
          // ChatMessage(
          //   text: 'สวัสดี',
          //   sender: 'Me',
          //   isUser: true,
          //   time: DateTime.now(),
          // ),
          ];
  List faq = ['ทำอะไรได้บ้าง', 'ขอเอกสารลา', 'ขอเอกสารลาออก', 'ขอเอกสารเบิกเงิน', 'ขอเอกสารทำงานล่วงเวลา'];
  TextEditingController _controller = TextEditingController();
  
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
                              child: InkWell(
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
                                }: () => {launch(message.file_url)},
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

  Future getFile(var intent) async{
    var url = Uri.http('localhost:8000','/api/get-file/${intent}');
    var response = await http.get(url);
    var result = utf8.decode(response.bodyBytes);
    if(response.statusCode == 200){
      return jsonDecode(result);
    }else{
      return;
    }
  }

  void sendMessage() async {
    final text = _controller.text;
    if (text.isEmpty) {
      return;
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
      print(dialogflow);
      final response = await dialogflow.detectIntent(text);
      print(response.queryResult.intent.displayName);
      final message = response.queryResult.fulfillmentText;

      // await getFile(response.queryResult.intent.displayName);
      // final file = await getFile(response.queryResult.intent.displayName);
      setState(() {
        messages.add(
          ChatMessage(
            text: message,
            sender: 'Bot',
            time: DateTime.now(),
            file_url: ''
          ),
        );
        isLoading = false;
      });
      // if (file){
      //     setState(() {
      //     messages.add(
      //       ChatMessage(
      //         text: file["name"],
      //         sender: 'Bot',
      //         time: DateTime.now(),
      //         file_url: file['file']
      //       ),
      //     );
      //     isLoading = false;
      //   });
      // }
      
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