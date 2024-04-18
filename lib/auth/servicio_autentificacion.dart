import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServicioAutenticacion {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> registrarUsuario(String email, String password, String nombre, String apellido, String telefono,/* String sexo*/) async {
    try {
      // Registro de usuario en Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Guardar datos adicionales en Firestore
      await _firestore.collection('usuarios').doc(userCredential.user!.uid).set({
        'email':email,
        'password':password,
        'nombre': nombre,
        'apellido': apellido,
        'telefono': telefono,
        /*'sexo': sexo,*/
      });

      return null; // Registro exitoso
    } catch (e) {
      return e.toString(); // Error durante el registro
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      // Inicio de sesión con Firebase Authentication.
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      return null; // Inicio de sesión exitoso
    } catch (e) {
      return e.toString(); // Error durante el inicio de sesión
    }
  }

  User? getUsuariActual() {
    return _auth.currentUser;
  }
}
