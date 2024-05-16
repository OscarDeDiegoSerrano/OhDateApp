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

  Future<void> enviarMissatge(String idReceptor, String missatge, String salaId) async {
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

    await _firestore
        .collection("SalesChat")
        .doc(salaId)
        .collection("Missatges")
        .add(nouMissatge.retornaMapaMissatge());

    // Actualizar el último mensaje y timestamp en la sala de chat
    await _firestore.collection("SalesChat").doc(salaId).update({
      'ultimoMensaje': missatge,
      'timestamp': timestamp,
    });
  }

  Stream<QuerySnapshot> getMissatges(String idUsuariActual, String idReceptor, String salaId) {
    return _firestore
        .collection("SalesChat")
        .doc(salaId)
        .collection("Missatges")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  Future<String> crearNovaSalaDeChat(String idReceptor) async {
    final String idUsuariActual = _auth.currentUser!.uid;

    List<String> idsUsuaris = [
      idUsuariActual,
      idReceptor,
    ];
    idsUsuaris.sort();
    String idSalaChat = idsUsuaris.join("_");

    DocumentReference salaChatRef = _firestore.collection("SalesChat").doc(idSalaChat);
    DocumentSnapshot salaChatSnapshot = await salaChatRef.get();

    if (!salaChatSnapshot.exists) {
      await salaChatRef.set({
        'usuarios': idsUsuaris,
        'ultimoMensaje': '',
        'timestamp': FieldValue.serverTimestamp(),
      });
    }

    return idSalaChat;
  }
}
