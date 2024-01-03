import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piramjuego/infrastructure/models/carta_model.dart';
import 'package:piramjuego/presentation/providers/baraja_provider.dart';
import 'package:piramjuego/presentation/providers/piramide_provider.dart';

class JuegoPiramideScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtiene el estado actual de la pirámide
    // En tu pantalla:
    final barajaNotifier = ref.watch(barajaProvider.notifier);
    final piramide = barajaNotifier.piramide;


    return Scaffold(
      appBar: AppBar(title: Text('Juego de Pirámide')),
      body: Column(
        children: [
          for (int nivel = 0; nivel < piramide.length; nivel++)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int posicion = 0; posicion < piramide[nivel].length; posicion++)
                  InkWell(
                    onTap: () => ref.read(barajaProvider.notifier).voltearCartaEnPiramide(nivel, posicion),
                    child: piramide[nivel][posicion] != null
                      ? _buildPlayingCard(piramide[nivel][posicion])
                      : Container(), // Espacio vacío o carta boca abajo
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildPlayingCard(Carta? carta) {
  if (carta == null) {
    // Aquí devuelves un widget que represente una carta boca abajo.
    return Image.asset('assets/images/carta_boca_abajo.png', width: 40, height: 60);
  } else {
    // Aquí conviertes y muestras la carta usando PlayingCardView o un widget personalizado.
    // Por ejemplo, si tienes una imagen para cada carta, podrías hacer algo así:
    String imagePath = 'assets/images/${carta.palo}_${carta.valor}.png';
    return Image.asset(imagePath, width: 40, height: 60);
  }
}
}

