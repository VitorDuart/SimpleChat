import 'package:socket_io/socket_io.dart';

main() {
  var io = Server();
  io.on('connection', (client) {
    print('User: ${client.id} connected');

    client.on('message', (msg) {
      var data = {
        'user': client.id,
        'message': msg,
        'date': DateTime.now().toString(),
      };

      print(data);

      client.broadcast.emit('message', data);
      //client.emit('message', data);
    });
  });
  io.listen(3000);
}
