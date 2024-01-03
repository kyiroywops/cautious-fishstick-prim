import 'package:flutter/material.dart';

class JuegoPiramideScreen extends StatelessWidget {
  const JuegoPiramideScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Aquí podrías generar las cartas de tu baraja o recibir la baraja como parámetro

    return Scaffold(
      appBar: AppBar(
        title: const Text('Juego de Pirámide'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int row = 1; row <= 4; row++) // Ajusta el 4 al número de filas que desees
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(row, (index) => _buildCardPlaceholder()),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardPlaceholder() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        width: 40,  // Ajusta al tamaño de tu carta
        height: 60,  // Ajusta al tamaño de tu carta
        decoration: BoxDecoration(
          color: Colors.blueGrey,  // Un color que represente la parte trasera de una carta
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
    );
  }
}
