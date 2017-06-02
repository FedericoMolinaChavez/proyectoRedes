import 'dart:io';
import 'dart:math';
class Matrix
{
  var rand = new Random()
List<List<String>> _matrix; 
int numa;
Matrix()
  {
    _matrix  = new List<List<int>>();
    numa = rand.nextInt(10);
  for (var i = 0; i < 40; i++) {
    List<int> list = new List<int>();

    for (var j = 0; j < 40; j++) {
      if ( j == 0)
        {
          list.add('*');
        }
      else if (i == 0)
        {
          list.add('*');
        }
      else if (i == 39)
        {
          list.add('*');
        }
      else if (j == 39)
        {
          list.add('*');
        }
      else if (j % numa == 1)
        {
          list.add('@');
        }
      else
      {
        list.add('-');
      }
    }

    _matrix.add(list);
  }
  }

List<List<String>> getMat()
  {
    return _matrix;
  }
  bool actualizar ()
    {
      if (numa > 0)
        {
          numa = numa - 1;
        }
    }
  int getNuma()
    {
      return numa;
    }
}


class ChatClient {
  Socket _socket;
  String _address;
  int _port;
  int x,y;
  Matrix _matrix;
  int puntos;
  ChatClient(Socket s, Matrix matrixx){
    this._socket = s;
    this._address = _socket.remoteAddress.address;
    this._port = _socket.remotePort;
    this._matrix = matrixx;
  this.x = 23;
  this.y = 18;
  this.puntos = 0;
  _matrix.getMat()[this.y][this.x] = '+';
    _socket.listen(messageHandler,
        onError: errorHandler,
        onDone: finishedHandler);
  }

  void messageHandler(List data){
    String message = new String.fromCharCodes(data).trim();
    distributeMessage(this, '$message',_matrix);
  }

  void errorHandler(error){
    print('${_address}:${_port} Error: $error');
    removeClient(this);
    _socket.close();
  }

  void finishedHandler() {
    print('${_address}:${_port} Disconnected');
    removeClient(this);
    _socket.close();
  }

  void write(String message,matrix){
    
    movement(message);
    String a = " ";
 
  for (var i = 0 ; i < 40 ; i++)
  {
  
    for (var j = 0; j < 40 ; j ++)
    {
      a += " "+_matrix.getMat()[i][j].toString();
    }
    a+="\n";
  }
    _socket.write(a);
  }

  void movement(String message)
    {
      String w = 'w';
      String a = 'a';
      String s = 's';
      String d = 'd';
     if (message == w and this.y < 38)
      {
        print (message);
        _matrix.getMat() [this.y][this.x] = '-';
        this.y = this.y - 1;
        if (_matrix.getMat() == '@')
          {
            this.puntos = this.puntos+1;
            _matrix.actualizar();
            
          }
        _matrix.getMat() [this.y][this.x] = '+';

      }
      if (message == a and this.x > 1)
        {
            print (message);
        _matrix.getMat() [this.y][this.x] = '-';
        this.x = this.x - 1;
        if (_matrix.getMat() == '@')
          {
            this.puntos = this.puntos+1;
            _matrix.actualizar();
            
          }
        _matrix.getMat() [this.y][this.x] = '+';
        }
      if (message == s and this.y > 1)
        {
            print (message);
        _matrix.getMat()[this.y][this.x] = '-';
        this.y = this.y + 1;
        if (_matrix.getMat() == '@')
          {
            this.puntos = this.puntos+1;
            _matrix.actualizar();
            
          }
        _matrix.getMat() [this.y][this.x] = '+';
        }
      if (message == d and this.x < 38)
        {
            print (message);
        _matrix.getMat()[this.y][this.x] = '-';
        this.x = this.x + 1;
        if (_matrix.getMat() == '@')
          {
            this.puntos = this.puntos+1;
            _matrix.actualizar();
            
          }
        _matrix.getMat() [this.y][this.x] = '+';
        }
    }
  void actualizar(Matrix matrix)
    {
        String a = " ";
 
  for (var i = 0 ; i < 40 ; i++)
  {
  
    for (var j = 0; j < 40 ; j ++)
    {
      a += " "+_matrix.getMat()[i][j].toString();
    }
    a+="\n";
  }
    _socket.write(a);
    }
}

ServerSocket server;
List<ChatClient> clients = [];

void main() {
  Matrix matriz = new Matrix();
  ServerSocket.bind(InternetAddress.ANY_IP_V4, 4567)
    .then((ServerSocket socket) {
      server = socket;
      server.listen((client) {
        handleConnection(client,matriz);
      });
    });
}

void handleConnection(Socket client, Matrix matrix){
  print('Connection from '
    '${client.remoteAddress.address}:${client.remotePort}');
  clients.add(new ChatClient(client,matrix));
  client.write("Welcome to dart-chat! "
    "There are ${clients.length - 1} other clients\n");
}

void distributeMessage(ChatClient client, String message,matrix){
  for (ChatClient c in clients) {
    if(matrix.get)
     if(c == client)
     {
      c.write(message,matrix);
    }
    else
      {
        c.actualizar(matrix);
      }
      
    
  }
    }


void removeClient(ChatClient client){
  clients.remove(client);
}
