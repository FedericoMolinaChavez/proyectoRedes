import 'dart:io';
import 'dart:async';

Socket socket = null;
Socket sockresp1 = null;
Socket sockresp2 = null;
bool getout1 = false;
bool getout2 = false;
bool getout3 = false;

void distributeStuff(data){
  
  if(data != null){
    
    if(!(getout1)){
      socket.write(
          new String.fromCharCodes(data).trim()
      );
    }

    if(!(getout2) && getout1){
      sockresp1.write(
        new String.fromCharCodes(data).trim()
      );  
    }

    if(!(getout3) && getout2 && getout3){
      sockresp2.write(
        new String.fromCharCodes(data).trim()
      );    
    }
    
  }

  if(getout1 && getout2 && getout3){
    print("Unable to connect");
    exit(1);
  }

}

void main() {
  
  

  Socket.connect("192.168.250.249", 4567)
  .then((Socket sock) {
      socket = sock;
      socket.listen(dataHandler, 
        onError: errorHandler, 
        onDone: doneHandler, 
        cancelOnError: false);
    })
    .catchError((AsyncError e) {
      print("Unable to connect: $e");
      getout1 = true;
      if (getout1 && getout2 && getout3){
        print("Unable to connect: $e");
        exit(1);
      }    
    });

  Socket.connect("192.168.250.33", 4567)
  .then((Socket sock) {
      sockresp1 = sock;
      sockresp1.listen(dataHandler, 
        onError: errorHandler, 
        onDone: doneHandler, 
        cancelOnError: false);
    })
    .catchError((AsyncError e) {
      print("Non");
      getout2 = true;
      if (getout1 && getout2 && getout3){
        print("Unable to connect: $e");
        exit(1);
      }    
    });


  Socket.connect("127.0.0.1", 4569)
  .then((Socket sock) {
      sockresp2 = sock;
      sockresp2.listen(dataHandler, 
        onError: errorHandler, 
        onDone: doneHandler, 
        cancelOnError: false);
    })
    .catchError((AsyncError e) {
      
      getout3 = true;
      if (getout1 && getout2 && getout3){
        print("Unable to connect: $e");
        exit(1);
      }    
    });


  stdin.listen((data) => distributeStuff(data)); 

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
