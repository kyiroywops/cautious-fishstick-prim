import 'package:flutter/material.dart';
import 'package:piramjuego/infrastructure/models/carta_model.dart';
import 'package:piramjuego/infrastructure/models/player_models.dart';

class ResultadoFinalScreen extends StatelessWidget {
  final Carta cartaFinal;
  final Player? jugador;

  ResultadoFinalScreen({required this.cartaFinal, this.jugador});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Resultado Final")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Carta Final: ${cartaFinal.valor} de ${cartaFinal.palo}'),
            SizedBox(height: 20),
            if (jugador != null)
              Text('Jugador coincidente: ${jugador!.name}'),
            if (jugador == null)
              Text('No se encontró coincidencia'),
            // ... Otros elementos de la UI
          ],
        ),
      ),
    );
  }
}
