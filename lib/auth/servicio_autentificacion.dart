import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class ServicioAutenticacion {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> registrarUsuario(String email, String password, String nombre, String apellido, String telefono, String sexo, String? imageUrl) async {
  try {
    // Registro de usuario en Firebase Authentication
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Subir imagen de perfil a Firebase Storage
    if (imageUrl != null) {
      //String imageName = email.replaceAll('@', '_').replaceAll('.', '_') + '.jpg'; // Nombre de la imagen basado en el correo electrónico
      //firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('imagenes/$imageName');


      // Guardar datos adicionales en Firestore
      await _firestore.collection('usuarios').doc(userCredential.user!.uid).set({
        'email': email,
        'password': password,
        'nombre': nombre,
        'apellido': apellido,
        'telefono': telefono,
        'sexo': sexo, // Nuevo campo para guardar el sexo
        'imagen': imageUrl, // Guardar la URL de la imagen en Firestore
      });
    } else {
      // Guardar datos adicionales en Firestore sin la imagen
      await _firestore.collection('usuarios').doc(userCredential.user!.uid).set({
        'email': email,
        'password': password,
        'nombre': nombre,
        'apellido': apellido,
        'telefono': telefono,
        'sexo': sexo, // Nuevo campo para guardar el sexo
      });
    }

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
