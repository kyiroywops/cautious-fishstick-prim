import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piramjuego/config/constants/cards_types.dart' as my;
import 'package:piramjuego/infrastructure/models/carta_model.dart' as my;
import 'package:piramjuego/presentation/providers/baraja_provider.dart';
import 'package:playing_cards/playing_cards.dart';

class JuegoPiramideScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final barajaNotifier = ref.watch(barajaProvider.notifier);
    final piramide = barajaNotifier.piramide;
    final cartasBocaAbajo = barajaNotifier.cartasBocaAbajo;

      print("Reconstruyendo JuegoPiramideScreen con estado actualizado");


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
                    onTap: () {
                      if (cartasBocaAbajo[nivel][posicion]) {
                        ref.read(barajaProvider.notifier).voltearCartaEnPiramide(nivel, posicion);
                      }
                    },
                    child: cartasBocaAbajo[nivel][posicion]
                        ? _buildCardBack()
                        : _buildPlayingCard(piramide[nivel][posicion])
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


  Widget _buildCardBack() {
    return Container(
      width: 40,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: Text('?', style: TextStyle(color: Colors.white, fontSize: 24)),
    );
  }

  Widget _buildPlayingCard(my.Carta? carta) {
    if (carta == null) return Container(); // Opción para manejar cartas nulas

    Suit suit = _convertMySuitToPlayingCardSuit(carta.palo);
    CardValue value = _convertMyValueToPlayingCardValue(carta.valor);

    double scale = 0.5; // Ajusta este valor según sea necesario

    return Container(
      width: 40, // Ancho del contenedor
      height: 60, // Altura del contenedor
      child: Transform.scale(
        scale: scale,
        child: PlayingCardView(card: PlayingCard(suit, value)),
      ),
    );
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
    print("Voltear siguiente carta llamado");

  
  var barajaNotifier = ref.read(barajaProvider.notifier);
  // Itera sobre las cartas boca abajo y voltear la primera que encuentre
  for (int nivel = 0; nivel < barajaNotifier.cartasBocaAbajo.length; nivel++) {
    for (int posicion = 0; posicion < barajaNotifier.cartasBocaAbajo[nivel].length; posicion++) {
      if (barajaNotifier.cartasBocaAbajo[nivel][posicion]) {
                print("Encontrada carta boca abajo en nivel $nivel, posición $posicion");

        barajaNotifier.voltearCartaEnPiramide(nivel, posicion);
        return; // Salir después de voltear una carta
      }
    }
  }
    print("No se encontraron cartas boca abajo");

}