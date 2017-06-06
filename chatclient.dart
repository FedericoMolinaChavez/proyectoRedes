import 'dart:io';
import 'dart:async';

Socket socket = null;  
int fails = 0;
int currentServer = 0;
bool exited = false;
bool getout1;
bool getout2;
bool getout3;
var servers = ['192.168.1.10','127.0.0.1','127.0.0.1'];

//while( !(exited) && (fails < servers.length) ){ //Mientras que todavia no se haya cumplido una condicion para que salga mas rapido, o no se haya fallado la conexion con cada uno de los servidores


void distributeStuff(data){

}

void main() {
  
  //Variables
  
  Socket.connect(servers[currentServer], 4567)
      .then((Socket sock){
        print('Connecting to  $servers, position $currentServer');
        socket = sock;
        socket.listen(
          dataHandler,
          onError : errorHandler,
          onDone : doneHandler,
          cancelOnError:false);
      })
      .catchError((AsyncError e){
        
        fails +=1;
        print('$fails: Unable to connect: $e');
        retry();

      });

  stdin.listen((data) => socket.write(new String.fromCharCodes(data).trim())); 

}


void dataHandler(data){
  print(new String.fromCharCodes(data).trim());
}

void errorHandler(error, StackTrace trace){
  
  print(error);

}

void retry(){

  if (fails<3){
    currentServer= (currentServer + 1)%3;
    Socket.connect(servers[currentServer], 4567)
      .then((Socket sock){
        print('Connecting to $servers, position $currentServer');
        socket = sock;
        print('here');
        fails = 0;
        socket.listen(
          dataHandler,
          onError : errorHandler,
          onDone : doneHandler,
          cancelOnError:false);
      })
      .catchError((AsyncError e){
        fails +=1;
        print('$fails: Unable to connect: $e');
        retry();
      });
    
  }else{
    exit(0);
  }
}

void doneHandler(){
  
  //socket.destroy();
  retry();
}
