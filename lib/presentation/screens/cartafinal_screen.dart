import 'package:flutter/material.dart';

class FinalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo de pantalla beige
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(70.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/vasofinal.png', // Ruta de tu imagen
                width: 200, // Ancho de la imagen
                height: 200, // Altura de la imagen
              ),
              SizedBox(height: 20), // Espacio entre imagen y texto
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'La proxima carta es la carta final, toma al seco.',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              SizedBox(height: 20), // Espacio entre texto y botón
          ElevatedButton(
            onPressed: () {
              // Acción del botón
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, // Fondo negro
              foregroundColor: Colors.black, // Texto en blanco
            ),
            child: Text(
              'Voltear carta',
              style: TextStyle(
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
            ],
          ),
        ),
      ),
    );
  }
}


  Widget _buildFinalCardContainer() {
    // Este método construirá el contenedor para la carta final.
    // Puedes personalizar la apariencia como quieras, aquí hay un ejemplo simple:
   return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 55,
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: AssetImage('assets/images/cartas/cartafinal.png'),
          ),
        ),
      ),
    );
  }
