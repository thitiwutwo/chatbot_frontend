import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:path/path.dart' as path;
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dialogflow/v2/auth_google.dart';
import 'package:meta/meta.dart';
import 'package:file_picker/file_picker.dart';
import 'package:iconsax/iconsax.dart';
import 'package:dotted_border/dotted_border.dart';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CreateRequestPage extends StatefulWidget {

  @override
  State<CreateRequestPage> createState() => _CreateRequestPageState();
}

class _CreateRequestPageState extends State<CreateRequestPage> with SingleTickerProviderStateMixin {
  TextEditingController intent = TextEditingController();
  TextEditingController question = TextEditingController();
  TextEditingController answer = TextEditingController();
  late AnimationController loadingController;
  File? _file;
  String? _fileName;
  String? _mimeType;
  PlatformFile? _platformFile;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'PDF']
    );
    if (result != null) {
      setState(() {
        _file = File(result.files.single.path!);
        _fileName = result.files.single.name;
        _platformFile = result.files.first;
        _mimeType = lookupMimeType(_file!.path);
      });
    }
  }

  @override
  void initState() {
    loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Data"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TextFormField(
              controller: intent,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.blue),
                  // borderRadius: BorderRadius.circular(50.0),
                ),
                labelText: 'Enter your intent',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: question,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.blue),
                  // borderRadius: BorderRadius.circular(50.0),
                ),
                labelText: 'Enter your question',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              minLines: 4,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              // keyboardType: TextInputType.text,
              controller: answer,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 3, color: Colors.blue),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                labelText: 'Enter your answer',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Upload your file',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'File should be jpg, png, pdf',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
            ),
            GestureDetector(
              onTap: _pickFile,
              child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(10),
                    dashPattern: [10, 4],
                    strokeCap: StrokeCap.round,
                    color: Colors.blue.shade400,
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                          color: Colors.blue.shade50.withOpacity(.3),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.folder_open,
                            color: Colors.blue,
                            size: 40,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Select your file',
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey.shade400),
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
            _platformFile != null
                ? Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selected File',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    offset: Offset(0, 1),
                                    blurRadius: 3,
                                    spreadRadius: 2,
                                  )
                                ]),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Icon(
                                    Iconsax.document,
                                    color: Colors.blue,
                                    size: 40,
                                  ),
                                  // Image.file(_file!, width: 70,)
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _platformFile!.name,
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '${(_platformFile!.size / 1024).ceil()} KB',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade500),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                          height: 5,
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.blue.shade50,
                                          ),
                                          child: LinearProgressIndicator(
                                            value: loadingController.value,
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ))
                : Container(),
            SizedBox(height: 20),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  textStyle: MaterialStateProperty.all(TextStyle(fontSize: 20)),
                  padding: MaterialStateProperty.all(
                      EdgeInsets.fromLTRB(50, 20, 50, 20)),
                ),
                onPressed: () {
                  print(intent.text);
                  print(question.text);
                  print(answer.text);
                  createIntent(intent.text, question.text, answer.text);
                  if(_file != null){
                     _uploadFile(intent.text);
                  }
                  //  ------------------------- แก้ส่วนนี้ -------------------------
                  //  - สร้างตัวแปรมาเพื่อส่งค่าเข่า function

                  // getIntent('testIntent3').then((value) {
                  //   updateIntent(value).then((value) {
                  //     Navigator.pop(context, 'create');
                  //   });
                  // });
                  // final snackBar = SnackBar(content: const Text('Add success !'));
                  // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  setState(() {
                    intent.clear();
                    question.clear();
                    answer.clear();
                    
                  });
                  // Navigator.push(context,
                  // MaterialPageRoute(builder: (context) => ReadPage()));
                },
                child: Text("Submit")),
          ],
        ),
      ),
    );
  }
  Future<void> _uploadFile(String nameIntent) async {
    if (_file == null) {
      return;
    }

    final stream = http.ByteStream(_file!.openRead());
    final length = await _file!.length();

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://172.20.10.5:8000/api/upload-file'),
    );
    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
    });
    request.fields['name'] = _fileName!; // Set the name of the file here
    request.fields['intent'] = nameIntent;

    final multipartFile = http.MultipartFile(
      'file',
      stream,
      length,
      filename: path.basename(_file!.path),
      contentType: MediaType.parse(_mimeType!),
    );
    request.files.add(multipartFile);

    final response = await http.Response.fromStream(await request.send());
    print(response.body);
  }

  Future createIntent(String nameIntent, String question, String answer) async {
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/credentials/admin_credentials.json")
            .build();
    var response = await authGoogle.post(
        'https://dialogflow.googleapis.com/v2/projects/${authGoogle.getProjectId}/agent/intents',
        headers: {
          HttpHeaders.authorizationHeader: "Bearer ${authGoogle.getToken}"
        },
        body:
            "{'displayName': '$nameIntent','messages': [{'text': {'text': ['$answer']}}],'trainingPhrases': [{'type': 'EXAMPLE','parts': [{'text': '$question'}]}],'parameters': [],'priority': 500000}");
    print(json.decode(response.body));
    // _uploadFile(nameIntent);
    return json.decode(response.body);
  }

  Future updateIntent(String intentId) async {
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/credentials/admin_credentials.json")
            .build();
    var response = await http.patch(
        'https://dialogflow.googleapis.com/v2/projects/${authGoogle.getProjectId}/agent/intents/$intentId',
        headers: {
          HttpHeaders.authorizationHeader: "Bearer ${authGoogle.getToken}"
        },
        body:
            "{'displayName': 'testIntent3','messages': [{'text': {'text': ['ใช่ นี่คือการทดสอบ2']}}],'trainingPhrases': [{'type': 'EXAMPLE','parts': [{'text': 'นี่คือการทดสอบใช่ไหม2'}]}],'parameters': [],'priority': 500000}");
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  Future getIntent(String nameIntent) async {
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/credentials/admin_credentials.json")
            .build();
    var response = await http.get(
      'https://dialogflow.googleapis.com/v2/projects/${authGoogle.getProjectId}/agent/intents',
      headers: {
        HttpHeaders.authorizationHeader: "Bearer ${authGoogle.getToken}"
      },
    );
    var jsonResponse = json.decode(response.body);
    var intents = jsonResponse["intents"]; //get all intents
    for (var intent in intents) {
      if (intent['displayName'] == nameIntent) {
        print(intent['displayName']);
        print(intent['name'].split('/').last);
        return intent['name'].split('/').last;
      }
    }
    // print(json.decode(response.body));
    return json.decode(response.body);
  }
}