
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ohdate_app/models/missatge.dart';

class ServeiChat {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUsuaris() {

    return _firestore.collection("usuaris").snapshots().map((event) {

      return event.docs.map((document) {

        final usuari = document.data();
        return usuari;
      }).toList();
    });
  }

  Future<void> enviarMissatge(String idReceptor, missatge) async {

    final String idUsuariActual = _auth.currentUser!.uid;
    final String emailUsuariActual = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Missatge nouMissatge = Missatge(
      idAutor: idUsuariActual, 
      emailAutor: emailUsuariActual, 
      idReceptor: idReceptor, 
      missatge: missatge, 
      timestamp: timestamp,
    );

    // Construim l'id de la sala de chat d'aquest missatge.
    List<String> idsUsuaris = [
      idUsuariActual,
      idReceptor,
    ];
    idsUsuaris.sort();
    String idSalaChat = idsUsuaris.join("_");

    await _firestore
      .collection("SalesChat")
      .doc(idSalaChat)
      .collection("Missatges")
      .add(nouMissatge.retornaMapaMissatge());
  }

  Stream<QuerySnapshot> getMissatges(String idUsuariActual, idReceptor){
    //Volem trobar la SalaChat formada per l'ID dels dos usuaris.
    //((idUsuariActual i idReceptor))
    List<String> idsUsuaris = [idUsuariActual, idReceptor];
    idsUsuaris.sort();
    String idSalaChat = idsUsuaris.join("_");

    return _firestore
      .collection("SalesChat")
      .doc(idSalaChat)
      .collection("Missatges")
      .orderBy("timestamp", descending: false).snapshots();
  }
}