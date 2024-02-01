import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:piramjuego/config/constants/cards_types.dart' as my;
import 'package:piramjuego/infrastructure/models/player_models.dart';
import 'package:piramjuego/infrastructure/models/carta_model.dart' as my;
import 'package:piramjuego/presentation/providers/baraja_provider.dart';
import 'package:piramjuego/presentation/providers/barajascantidad_provider.dart';
import 'package:piramjuego/presentation/providers/cartasporjugador_provider.dart';
import 'package:piramjuego/presentation/providers/numerodepisos_provider.dart';
import 'package:piramjuego/presentation/providers/player_provider.dart';
import 'package:piramjuego/presentation/providers/sorbos_provider.dart';
import 'package:playing_cards/playing_cards.dart';

class ResultadoFinalScreen extends ConsumerStatefulWidget {

  final my.Carta cartaFinal;
  final List<Player> jugadoresCoincidentes;

  // Asegúrate de incluir un constructor que pase estas variables
  ResultadoFinalScreen({required this.cartaFinal, required this.jugadoresCoincidentes});



  @override
  _ResultadoFinalScreenState createState() => _ResultadoFinalScreenState();
}

class _ResultadoFinalScreenState extends ConsumerState<ResultadoFinalScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    // Inicializa el controlador de confeti aquí
    _confettiController = ConfettiController(duration: const Duration(seconds: 10));
    // Play the confetti animation when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(mounted) {
        _confettiController.play();
      }
    });
  }

  @override
  void dispose() {
    // Asegúrate de desechar el controlador de confeti aquí
    _confettiController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
 

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final paddingTop = screenHeight * 0.05;
    final paddingTopBoton = screenHeight * 0.08;
    final paddingRight = screenWidth * 0.05;


   
    final jugadores = ref.watch(playerProvider);
    final sorbosX2 = ref
        .watch(sorbosX2Provider.state)
        .state; // Accede al estado de sorbos x2
    final cartasPorJugador = ref.read(cartasPorJugadorProvider.state).state;
    final numeroDeBarajas = ref.read(numeroBarajasProvider.state).state;
    final numerodePisos = ref.read(pisoProvider.state).state;


    void reiniciarYComenzarNuevoJuego() {
      ref.read(barajaProvider.notifier).resetearJuego();
      ref.read(barajaProvider.notifier).generarYAsignarCartas(jugadores,
          cartasPorJugador, sorbosX2, numeroDeBarajas, numerodePisos);
    }
    

    return Scaffold(
      backgroundColor: Colors.black26,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive, // Se expande en todas direcciones
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              maxBlastForce: 100,
              minBlastForce: 80,
              gravity: 0.3,
              colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple], // Colores del confeti
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: paddingTop),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Text(
                        'La carta final es',
                        style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    _buildPlayingCard(widget.cartaFinal, context, isLarge: true),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Jugadores que coinciden',
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    if (widget.jugadoresCoincidentes.isNotEmpty)
                      ...widget.jugadoresCoincidentes
                          .map((jugador) =>
                              _buildJugadorContainer(jugador, context))
                          .toList(),
                    if (widget.jugadoresCoincidentes.isEmpty)
                      Text('No se encontró coincidencia',
                          style: TextStyle(fontSize: 24, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: paddingTopBoton,
            right: paddingRight,
            child: ElevatedButton.icon(
              onPressed: () {
                // Asegúrate de que todas las variables necesarias están definidas y son pasadas correctamente.
                reiniciarYComenzarNuevoJuego();
                // Si necesitas actualizar el estado de los jugadores también, hazlo aquí.
                ref.read(playerProvider.notifier).setPlayers(jugadores);
                // Navegas de vuelta a la pantalla que inicia el juego o donde sea adecuado
                GoRouter.of(context).go('/cartasasignadas');
              },
              icon: Icon(Icons.flag, color: Colors.black),
              label: Text('Terminar Partida',
                  style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJugadorContainer(Player jugador, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(jugador.avatar),
                  radius: 30,
                ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                jugador.name,
                style: TextStyle(
                    fontSize: 21,
                    color: Colors.white,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w700),
              ),
            ),
              ],
            ),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            children: jugador.cartas
                .map((c) => _buildPlayingCard(c, context, isLarge: false))
                .toList(),
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
