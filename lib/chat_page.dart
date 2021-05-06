import 'package:socket_io_client/socket_io_client.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  Socket socket;
  List<Map<String, dynamic>> msgs = [];

  @override
  void initState() {
    super.initState();
    connectAndListen();
  }

  void connectAndListen() {
    socket = io('http://localhost:3000');

    socket.onConnect((_) {
      print('connect ok');
    });

    socket.on('message', handleMessage);
  }

  void handleMessage(data) {
    setState(() {
      msgs.add(data);
    });
  }

  List<Widget> _buildListMsg() {
    List<Widget> textMsg = <Widget>[];

    if (msgs.length == 0) {
      return <Widget>[];
    } else {
      for (Map<String, dynamic> msg in msgs) {
        textMsg.add(
          Row(
            mainAxisAlignment: socket.id == msg['user']
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              _messageCard(msg),
            ],
          ),
        );
      }
    }

    return textMsg;
  }

  Container _messageCard(Map<String, dynamic> data) {
    return Container(
      width: 150,
      margin: EdgeInsets.all(10),
      color: socket.id == data['user']
          ? Colors.blue[100]
          : Colors.greenAccent[200],
      child: ListTile(
        title: Text(data['message']),
        subtitle: Text(data['date']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        shrinkWrap: true,
        children: _buildListMsg(),
      ),
      bottomNavigationBar: TextField(
        onChanged: (text) {
          setState(() {
            msgs.add({
              'user': socket.id,
              'message': text,
              'date': DateTime.now().toString(),
            });
          });
          socket.emit('message', text);
        },
      ),
    );
  }
}
