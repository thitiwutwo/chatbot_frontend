import 'package:flutter/material.dart';
import 'package:chatbot_frontend/pages/user/add.dart';

class ChatList extends StatefulWidget {
  // const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List dataListItem = [
    'ขอใบเบิกเงินเดือน',
    'ขอขั้นตอนการยื่นเอกสารขอใบเบิกเงินเดือน'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Q & A"),
      ),
      body: listData(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddPage()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget listData() {
    return ListView.builder(
      itemCount: dataListItem.length,
      itemBuilder: (BuildContext ctx, index) {
        // Display the list item
        return Dismissible(
          key: UniqueKey(),

          // only allows the user swipe from right to left
          direction: DismissDirection.endToStart,

          // Remove this title from the list
          // In production enviroment, you may want to send some request to delete it on server side
          onDismissed: (_) {
            setState(() {
              dataListItem.removeAt(index);
            });
            final snackBar = SnackBar(
              content: const Text('delete completed'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },

          // This will show up when the user performs dismissal action
          // It is a red background and a trash icon
          background: Container(
            color: Colors.red,
            margin: const EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.centerRight,
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),

          // Display item's title
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: ListTile(
              title: Text(dataListItem[index]),
            ),
          ),
        );
      },
    );
  }
}
