import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:piramjuego/config/constants/cards_types.dart' as my;
import 'package:piramjuego/infrastructure/models/carta_model.dart' as my;
import 'package:piramjuego/presentation/providers/baraja_provider.dart';
import 'package:piramjuego/presentation/providers/player_provider.dart'; // Importa tu playerProvider
import 'package:piramjuego/presentation/widgets/boton_atras.dart';
import 'package:playing_cards/playing_cards.dart';


class CartasAsignadasScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jugadores = ref.watch(playerProvider);

  void onGenerateAndAssignPressed() {
    ref.read(barajaProvider.notifier).generarYAsignarCartas(jugadores, 2);
    ref.read(playerProvider.notifier).setPlayers(jugadores);
  }

    
    return Scaffold(
 
      backgroundColor: Theme.of(context).colorScheme.onBackground,

      body: Column(
        
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                    child: BotonAtras(),
                  ),
                  ElevatedButton(
                    onPressed: onGenerateAndAssignPressed ,
                    child: Text('Generar y Asignar Cartas', style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w600), // Letra blanca
                        
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: jugadores.length,
              itemBuilder: (context, index) {
                final jugador = jugadores[index];
                print("Mostrando cartas de ${jugador.name}: ${jugador.cartas.map((c) => c.toString()).join(', ')}");

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(jugador.avatar),
                      radius: 30,
                    ),
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(jugador.name, style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w800,
                          fontSize: 17
                          ), 
                          
                          // Letra blanca
                      ),
                    ),
                    subtitle: jugador.cartas.isNotEmpty
                   ? Row(
                            children: jugador.cartas
                                .map((c) => _buildPlayingCard(c))
                                .toList(),
                          )
                        : Text("Sin cartas", style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w400,
                          fontSize: 17
                          
                        ),),
                  ),
                );
              },
            )
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: ElevatedButton(
                onPressed: () {
                 
                      GoRouter.of(context).go('/juego');
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Jugar',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w600), // Letra blanca
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.onPrimary, // Fondo negro
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Bordes redondeados
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 44, vertical: 10), // Padding interior del botón
                ),
              ),
          )
        ],
      ),
    );
  }
}

 
Widget _buildPlayingCard(my.Carta carta) {
  // Utiliza el prefijo 'my' para referirte a tus propios tipos
  Suit suit = _convertMySuitToPlayingCardSuit(carta.palo);
  CardValue value = _convertMyValueToPlayingCardValue(carta.valor);

  // Usa PlayingCardView para mostrar la carta
  return Container(
    width: 60,  // Ancho de la carta
    height: 80,  // Altura de la carta
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


