import 'package:ansicolor/ansicolor.dart';

main() {
	print(ansi_demo());
  List<List<String>> matrix = new List<List<String>>();
  for (var i = 0; i < 20; i++) {
    List<String> list = new List<String>();

    for (var j = 0; j < 20; j++) {
      if ( j == 0)
        {
          list.add('*');
        }
      else if (i == 0)
        {
          list.add('*');
        }
      else if (i == 19)
        {
          list.add('*');
        }
      else if (j == 19)
        {
          list.add('*');
        }
      else
      {
        list.add(' ');
      }
    }

    matrix.add(list);
  }
String a = "";
 
  for (var i = 0 ; i < 20 ; i++)
  {
  
  	for (var j = 0; j < 20 ; j ++)
  	{
  		a += " "+matrix[i][j];
  	}
  	a+="\n";
  }
  print (a);
}

