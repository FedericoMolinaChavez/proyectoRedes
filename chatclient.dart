import 'dart:io';
import 'package:ansicolor/ansicolor.dart';
Socket socket;

void main() {
  Socket.connect("192.168.1.100", 4567)
    .then((Socket sock) {
      socket = sock;
      socket.listen(dataHandler, 
        onError: errorHandler, 
        onDone: doneHandler, 
        cancelOnError: false);
    })
    .catchError((AsyncError e) {
      print("Unable to connect: $e");
      exit(1);
    });

  stdin.listen((data) => 
      socket.write(
        new String.fromCharCodes(data).trim()));
}

void dataHandler(data){
  print(new String.fromCharCodes(data).trim());
}

void errorHandler(error, StackTrace trace){
  print(error);
}

void doneHandler(){
  //socket.destroy();
  exit(0);
}
