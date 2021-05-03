import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  Socket socket;
  List<Widget> messages;
  String url = 'http://localhost:3000';
  List<String> items = ['1', '2', '3', '4', '1', '2', '3', '4'];

  @override
  void initState() {
    super.initState();
    connectToServer();
    messages = <Widget>[];
  }

  void connectToServer() {
    socket = io(url);
    print('trying..');

    socket.on('connect', (_) {
      print('connect ok');
    });

    // Stander Handlers
    socket.on('fromServer', (_) => print(_));

    socket.on('message', handleMessage);
  }

  void handleMessage(data) {
    setState(() {
      messages.add(Container(
        color: Colors.lightBlueAccent,
        width: 100,
        padding: EdgeInsets.all(7),
        margin: EdgeInsets.only(left: 7, top: 15),
        child: Text(data['message']),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: messages,
      ),
      bottomNavigationBar: TextField(
        onChanged: (text) {
          socket.emit('message', text);
        },
      ),
    );
  }
}
