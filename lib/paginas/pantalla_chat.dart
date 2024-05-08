import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ohdate_app/servicios/servicio_autentificacion.dart';
import 'package:ohdate_app/components/bombolla_missatge.dart';
import 'package:ohdate_app/servicios/servei_chat.dart';

class PaginaChat extends StatefulWidget {

  final String emailAmbQuiParlem;
  final String idReceptor;

  const PaginaChat({
    super.key,
    required this.emailAmbQuiParlem,
    required this.idReceptor, required String nombreUsuario,
  });

  @override
  State<PaginaChat> createState() => _PaginaChatState();
}

class _PaginaChatState extends State<PaginaChat> {

  final TextEditingController controllerMissatge = TextEditingController();
  final ScrollController controllerScroll = ScrollController();

  final ServeiChat _serveiChat = ServeiChat();
  final ServicioAutenticacion servicioAutenticacion = ServicioAutenticacion();

  // Variable pel teclat d'un mòbil.
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {

    focusNode.dispose();
    controllerMissatge.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    focusNode.addListener(() { 
      Future.delayed(
        const Duration(milliseconds: 500),
        () => ferScrollCapAvall(), 
      );
    });

    // Ens esperem un moment, i llavors movem cap a baix.
    Future.delayed(
      const Duration(milliseconds: 500),
      () => ferScrollCapAvall(), 
    );
  }

  void ferScrollCapAvall() {

    controllerScroll.animateTo(
      controllerScroll.position.maxScrollExtent, 
      duration: const Duration(seconds: 1), 
      curve: Curves.fastOutSlowIn, 
    );
  }

  void enviarMissatge() async {

    if (controllerMissatge.text.isNotEmpty) {

      // Enviar el missatge.
      await _serveiChat.enviarMissatge(
        widget.idReceptor, 
        controllerMissatge.text);

      // Netejar el camp.
      controllerMissatge.clear();

    }
    ferScrollCapAvall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.emailAmbQuiParlem),
      ),
      body: Column(
        children: [
          // Zona missatges.
          Expanded(
            child: _construirLlistaMissatges(),
          ),

          // Zona escriure missatge.
          _construirZonaInputUsuari(),
        ],
      ),
    );
  }

  Widget _construirLlistaMissatges() {

    String idUsuariActual = ServicioAutenticacion().getUsuariActual()!.uid;

    return StreamBuilder(
      stream: _serveiChat.getMissatges(idUsuariActual, widget.idReceptor), 
      builder: (context, snapshot){

        // Cas que hi hagi error.
        if (snapshot.hasError) {
          return const Text("Error carregant missatges.");
        }

        // Estar encara carregant.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Carregant...");
        }

        // Retornar dades (ListView).
        return ListView(
          controller: controllerScroll,
          children: snapshot.data!.docs.map((document) => _construirItemMissatge(document)).toList(),
        );

      },
    );
  }

  Widget _construirItemMissatge(DocumentSnapshot documentSnapshot){
    

    // final data = document... (altra opció).
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

    // Saber si el mostrem a l'esquerra o a la dreta.

    // Si és usuari acutal.
    bool esUsuariActual = data["nombre"] == ServicioAutenticacion().getUsuariActual()!.uid;

    // (Operador ternari).
    var aliniament = esUsuariActual ? Alignment.centerRight : Alignment.centerLeft;
    var colorBombolla = esUsuariActual ? Colors.green[200] : Colors.amber[200];
    return Container(
      alignment: aliniament,
      child: BombollaMissatge(
        colorBombolla: colorBombolla??Colors.black,
        missatge: data["missatge"],
      ),
    );
  }

  Widget _construirZonaInputUsuari() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controllerMissatge,
              decoration: InputDecoration(
                fillColor: Color.fromARGB(255, 255, 255, 255),
                filled: true,
                hintText: "Escriu el missatge...",
              ),
            ),
          ),
          const SizedBox(width: 10,),
          IconButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 228, 88, 233)),
            ),
            icon: const Icon(Icons.send),
            color: Colors.white,
            onPressed: enviarMissatge, 
          ),
        ],
      ),
    );
  }
}