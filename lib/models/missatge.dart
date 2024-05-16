
import 'package:cloud_firestore/cloud_firestore.dart';

class Missatge {

  final String idAutor;
  final String emailAutor;
  final String idReceptor;
  final String missatge;
  final Timestamp timestamp;

  Missatge({
    required this.idAutor,
    required this.emailAutor,
    required this.idReceptor,
    required this.missatge,
    required this.timestamp,
  });

  Map<String, dynamic> retornaMapaMissatge() {
    return {
      "idAutor": idAutor,
      "emailAutor": emailAutor,
      "idReceptor": idReceptor,
      "missatge": missatge,
      "timestamp": timestamp,
    };
  }
}