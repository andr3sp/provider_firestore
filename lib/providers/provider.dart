import 'package:flutter/foundation.dart';

class MyProvider with ChangeNotifier {

  //Dentro de nuestro provider, creamos e inicializamos nuestra variable.
  
  String _nombre = "Text>Provider";



  //Creamos el metodo Get, para poder obtener el valor de mitexto
  
  String get nombre => _nombre; 

  //Ahora creamos el metodo set para poder actualizar el valor de _mitexto, 
  //este metodo recibe un valor newTexto de tipo String

  set nombre(String newNombre) {
    _nombre = newNombre; //actualizamos el valor
    notifyListeners(); //notificamos a los widgets que esten escuchando el stream.
  } 

}
