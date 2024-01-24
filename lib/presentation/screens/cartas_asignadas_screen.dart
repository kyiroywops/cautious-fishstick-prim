import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:piramjuego/config/constants/cards_types.dart' as my;
import 'package:piramjuego/infrastructure/models/carta_model.dart' as my;
import 'package:piramjuego/presentation/providers/baraja_provider.dart';
import 'package:piramjuego/presentation/providers/barajascantidad_provider.dart';
import 'package:piramjuego/presentation/providers/cartasporjugador_provider.dart';
import 'package:piramjuego/presentation/providers/gamemode_provider.dart';
import 'package:piramjuego/presentation/providers/numerodepisos_provider.dart';
import 'package:piramjuego/presentation/providers/player_provider.dart'; // Importa tu playerProvider
import 'package:piramjuego/presentation/providers/sorbos_provider.dart';
import 'package:piramjuego/presentation/widgets/boton_atras.dart';
import 'package:playing_cards/playing_cards.dart';
import 'package:url_launcher/url_launcher.dart';


class CartasAsignadasScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jugadores = ref.watch(playerProvider);
    final sorbosX2 = ref.watch(sorbosX2Provider.state).state; // Accede al estado de sorbos x2
    final cartasPorJugador = ref.read(cartasPorJugadorProvider.state).state;
    final numeroDeBarajas = ref.read(numeroBarajasProvider.state).state;
    final numerodePisos = ref.read(pisoProvider.state).state;

    final String discordUrl = 'https://discord.gg/tuComunidad';

  // Método para abrir el enlace de Discord
    void _launchDiscord(BuildContext context) async {
    if (await canLaunch(discordUrl)) {
      await launch(discordUrl);
    } else {
      // Mostrar error o manejar la situación
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir el enlace de Discord')),
      );
    }
  }





  void onGenerateAndAssignPressed() {
    ref.read(barajaProvider.notifier).generarYAsignarCartas(jugadores, cartasPorJugador, sorbosX2, numeroDeBarajas, numerodePisos);
    ref.read(playerProvider.notifier).setPlayers(jugadores);
  }

    final gameMode = ref.watch(gameModeProvider.state).state;

    
    return Scaffold(
 
      backgroundColor: Theme.of(context).colorScheme.onBackground,
       appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        leading: BotonAtras(),
        actions: [
          Container(
            margin: EdgeInsets.only(
                right: 8), // Espacio entre el contenedor y el botón de Discord
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.brown.withOpacity(0.8),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              gameMode == GameMode.custom ? 'Personalizada' : 'Rápida',
              style: TextStyle(color:Colors.white,  fontFamily: 'Lexend')
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: Icon(Icons.discord, color: Colors.white),
              onPressed: () => _launchDiscord(context),
            ),
          ),
        ],
      ),

      body: Stack(
        children: [
          SingleChildScrollView(
          
            child: Column(
              
              children: [
             
                
                  ListView.builder(
                    itemCount: jugadores.length,
                    padding: EdgeInsets.zero, // Establece el padding a cero
          
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
          
                    itemBuilder: (context, index) {
                      final jugador = jugadores[index];
                      print("Mostrando cartas de ${jugador.name}: ${jugador.cartas.map((c) => c.toString()).join(', ')}");
            
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
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
                  ),
                
               
              ],
            ),
          ),
             Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Botón Asignar Cartas
                  ElevatedButton.icon(
                    onPressed: onGenerateAndAssignPressed,
                    icon: Icon(Icons.refresh, color: Colors.white),
                    label: Text('Asignar Cartas', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    ),
                  ),
                  // Botón Jugar
                  ElevatedButton.icon(
                    onPressed: () => GoRouter.of(context).go('/juego'),
                    icon: Icon(Icons.play_arrow, color: Colors.white),
                    label: Text('Jugar', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
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


