import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piramjuego/config/constants/cards_types.dart' as my;
import 'package:piramjuego/infrastructure/models/carta_model.dart' as my;
import 'package:piramjuego/presentation/providers/baraja_provider.dart';
import 'package:playing_cards/playing_cards.dart';

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
                for (int posicion = 0;
                    posicion < piramide[nivel].length;
                    posicion++)
                  InkWell(
                    onTap: () => ref
                        .read(barajaProvider.notifier)
                        .voltearCartaEnPiramide(nivel, posicion),
                    child: piramide[nivel][posicion] != null
                        ? _buildPlayingCard(piramide[nivel][posicion])
                        : Container(), // Espacio vacío o carta boca abajo
                  ),
                  
              ],
            ),
            ElevatedButton(
              onPressed: () => voltearSiguienteCarta(ref),
              child: Text('Voltear Carta'),
            )
],
      ),
    );
  }

Widget _buildPlayingCard(my.Carta? carta) {
  if (carta == null) {
    // Un Container que simula una carta boca abajo
    return Container(
      width: 40,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: Text('?', style: TextStyle(color: Colors.white)),
    );
  } else {
    // Utiliza el prefijo 'my' para referirte a tus propios tipos
    Suit suit = _convertMySuitToPlayingCardSuit(carta.palo);
    CardValue value = _convertMyValueToPlayingCardValue(carta.valor);

    // Calcula la escala para el tamaño deseado de la carta
    double scale = 0.5; // Ajusta este valor según sea necesario

    // Usa PlayingCardView para mostrar la carta con una escala reducida
    return Container(
      width: 40, // Ancho del contenedor
      height: 60, // Altura del contenedor
      child: Transform.scale(
        scale: scale,
        child: PlayingCardView(card: PlayingCard(suit, value)),
      ),
    );
  }
}
  Suit _convertMySuitToPlayingCardSuit(my.Suit mySuit) {
    switch (mySuit) {
      case my.Suit.hearts:
        return Suit.hearts;
      case my.Suit.spades:
        return Suit.spades;
      case my.Suit.diamonds:
        return Suit.diamonds;
      case my.Suit.clubs:
        return Suit.clubs;
      default:
        throw Exception('Invalid suit');
    }
  }

  CardValue _convertMyValueToPlayingCardValue(my.CardValue myValue) {
    switch (myValue) {
      case my.CardValue.ace:
        return CardValue.ace;
      case my.CardValue.two:
        return CardValue.two;
      case my.CardValue.three:
        return CardValue.three;
      case my.CardValue.four:
        return CardValue.four;
      case my.CardValue.five:
        return CardValue.five;
      case my.CardValue.six:
        return CardValue.six;
      case my.CardValue.seven:
        return CardValue.seven;
      case my.CardValue.eight:
        return CardValue.eight;
      case my.CardValue.nine:
        return CardValue.nine;
      case my.CardValue.ten:
        return CardValue.ten;
      case my.CardValue.jack:
        return CardValue.jack;
      case my.CardValue.queen:
        return CardValue.queen;
      case my.CardValue.king:
        return CardValue.king;
      default:
        throw Exception('Invalid card value');
    }
  }
}
void voltearSiguienteCarta(WidgetRef ref) {
  // Encuentra la primera carta boca abajo.
  for (int nivel = 0; nivel < ref.read(barajaProvider.notifier).piramide.length; nivel++) {
    for (int posicion = 0; posicion < ref.read(barajaProvider.notifier).piramide[nivel].length; posicion++) {
      if (ref.read(barajaProvider.notifier).piramide[nivel][posicion] == null) {
        // Voltea la carta.
        ref.read(barajaProvider.notifier).voltearCartaEnPiramide(nivel, posicion);
        return; // Salir después de voltear una carta.
      }
    }
  }
}