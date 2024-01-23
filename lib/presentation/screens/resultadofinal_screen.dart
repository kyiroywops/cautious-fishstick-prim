import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:piramjuego/config/constants/cards_types.dart' as my;
import 'package:piramjuego/infrastructure/models/player_models.dart';
import 'package:piramjuego/infrastructure/models/carta_model.dart' as my;
import 'package:playing_cards/playing_cards.dart';

class ResultadoFinalScreen extends StatelessWidget {
  final my.Carta cartaFinal;
  final List<Player> jugadoresCoincidentes;

  ResultadoFinalScreen({required this.cartaFinal, required this.jugadoresCoincidentes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildPlayingCard(cartaFinal, context, isLarge: true),
            SizedBox(height: 20),
            if (jugadoresCoincidentes.isNotEmpty) ...jugadoresCoincidentes.map((jugador) => _buildJugadorContainer(jugador, context)).toList(),
            if (jugadoresCoincidentes.isEmpty) Text('No se encontró coincidencia', style: TextStyle(fontSize: 24, color: Colors.white)),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                GoRouter.of(context).go('/cartasasignadas');
              },
              icon: Icon(Icons.flag, color: Colors.black),
              label: Text('Terminar Partida', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(primary: Colors.white, padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
            ),
          ],
        ),
      ),
    );
  }

    Widget _buildJugadorContainer(Player jugador, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(jugador.avatar),
            radius: 30,
          ),
          Text(
            jugador.name,
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            children: jugador.cartas.map((c) => _buildPlayingCard(c, context, isLarge: false)).toList(),
          ),
        ],
      ),
    );
  }


  Widget _buildPlayingCard(my.Carta carta, BuildContext context,
      {required bool isLarge}) {
    var suit = _convertMySuitToPlayingCardSuit(carta.palo);
    var value = _convertMyValueToPlayingCardValue(carta.valor);

    // Determina el tamaño de la carta en base a si es grande o pequeña
    var screenSize = MediaQuery.of(context).size;
    var cardWidth = isLarge
        ? screenSize.width * 0.4
        : 52.0; // 50% del ancho de la pantalla para la carta grande
    var cardHeight = cardWidth * 1.4;

    return Container(
      width: cardWidth,
      height: cardHeight,
      child: PlayingCardView(card: PlayingCard(suit, value)),
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
