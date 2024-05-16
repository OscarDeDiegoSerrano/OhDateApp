import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServicioAutenticacion {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> registrarUsuario(String email, String password, String nombre, String apellido, String telefono, String sexo, String edad) async {
    try {
      // Registro de usuario en Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Creación de documento de usuario en Firestore
      await _firestore.collection('usuarios').doc(userCredential.user!.uid).set({
        'email': email,
        'password': password, // Este dato no debería guardarse, ya que Firebase Auth lo maneja internamente
        'nombre': nombre,
        'apellido': apellido,
        'telefono': telefono,
        'sexo': sexo, // Nuevo campo para guardar el sexo
        'edad': edad, // Nuevo campo para guardar la edad
        'listaConversaciones': [],
      });
      
      return null; // Registro exitoso
    } catch (e) {
      return e.toString(); // Devuelve el mensaje de error
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
      return e.toString(); // Devuelve el mensaje de error
    }
  }

  User? getUsuariActual() {
    return _auth.currentUser;
  }
}
