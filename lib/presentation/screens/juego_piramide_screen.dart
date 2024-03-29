import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:piramjuego/config/constants/cards_types.dart' as my;
import 'package:piramjuego/infrastructure/models/carta_model.dart' as my;
import 'package:piramjuego/infrastructure/models/player_models.dart';
import 'package:piramjuego/presentation/providers/baraja_provider.dart';
import 'package:piramjuego/presentation/providers/cartacoincide_provider.dart';
import 'package:piramjuego/presentation/providers/forzarcarta_provider.dart';
import 'package:piramjuego/presentation/providers/jugadordebetomar_provider.dart';
import 'package:piramjuego/presentation/providers/player_provider.dart';
import 'package:playing_cards/playing_cards.dart';

class JuegoPiramideScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final barajaNotifier = ref.watch(barajaProvider.notifier);
    final jugadorDebeTomar = ref.watch(jugadorDebeTomarProvider);
    final int numeroDePisos = ref.watch(barajaProvider).piramide.length;

    final double cardWidth = numeroDePisos > 7 ? 40 : 55;
    final double cardHeight = numeroDePisos > 7 ? 55 : 70;
    final double cardScale = numeroDePisos > 7 ? 0.95 : 1;

    final double widthCartaAbajo = numeroDePisos > 7 ? 25 : 35;
    final double heightCartaAbajo = numeroDePisos > 7 ? 40 : 55;

    Future<bool> _onWillPop() async {
      bool shouldPop = (await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.grey.shade300, // Fondo del AlertDialog
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              titlePadding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 10.0),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              title: const Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Icon(
                  Icons.autorenew,
                  color: Colors.black,
                  size: 68.0,
                ),
              ),
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Text('¿Deseas salir?',
                          style: TextStyle(
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w800,
                              fontSize: 20))),
                  SizedBox(height: 8),
                  Text(
                      'Si presionas "Salir", irás a la pantalla asignar cartas y se reiniciará la partida.',
                      style: TextStyle(
                          fontFamily: 'Lexend', fontWeight: FontWeight.w400)),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No',
                      style: TextStyle(
                          fontFamily: 'Lexend', fontWeight: FontWeight.w800)),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Salir',
                      style: TextStyle(
                          fontFamily: 'Lexend', fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          )) ??
          false;

      return shouldPop;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        leading: Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 23),
            onPressed: () async {
              if (await _onWillPop()) {
                GoRouter.of(context).push('/cartasasignadas');
              }
            },
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      body: ValueListenableBuilder<bool>(
        valueListenable: barajaNotifier.reconstruir,
        builder: (context, value, child) {
          // Usa 'value' si es necesario para tomar decisiones en la UI
          final piramide = barajaNotifier.piramide;
          final cartasBocaAbajo = barajaNotifier.cartasBocaAbajo;

          return SingleChildScrollView(
            child: Column(
              children: [
                for (int nivel = 0; nivel < piramide.length; nivel++)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int posicion = 0;
                          posicion < piramide[nivel].length;
                          posicion++)
                        InkWell(
                            child: cartasBocaAbajo[nivel][posicion]
                                ? _buildCardBack(
                                    widthCartaAbajo, heightCartaAbajo)
                                : _buildPlayingCard(piramide[nivel][posicion],
                                    cardWidth, cardHeight, cardScale)),
                      if (nivel == 0)
                        Padding(
                          padding: const EdgeInsets.only(right: 50),
                          child: _buildFinalCardContainer(
                              widthCartaAbajo, heightCartaAbajo),
                        ),
                    ],
                  ),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: ElevatedButton.icon(
                    icon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.flip, color: Colors.grey[900]),
                    ), // Ícono al lado del texto
                    label: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Voltear Carta',
                        style: TextStyle(
                            fontFamily: 'Lexend',
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[900]),
                      ),
                    ),
                    onPressed: () => voltearSiguienteCarta(ref, context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    // Asumiendo que 'mostrarMensaje' es una variable booleana que controla la visibilidad
                    final mostrarMensaje =
                        ref.watch(mostrarMensajeCartaCoincideProvider);
                    if (mostrarMensaje) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 20.0),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors
                                .grey.shade300, // Color de fondo del contenedor
                            borderRadius: BorderRadius.circular(15.0),
                            border: const Border(
                              left: BorderSide(
                                color: Colors
                                    .red, // Cambiado a rojo para mayor visibilidad
                                width: 5.0, // Ancho del borde izquierdo
                              ),
                            ),
                          ),
                          child: const Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                                      child: Text(
                                        'Nadie tiene esa carta!',
                                        style: TextStyle(
                                          color: Colors
                                              .red, // Cambiado a rojo para mayor visibilidad
                                          fontWeight: FontWeight.w800,
                                          fontFamily: 'Lexend',
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        '¡No hubo coincidencia! Intenta de nuevo con "Voltear Carta".',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontFamily: 'Lexend',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox
                          .shrink(); // Devuelve un contenedor vacío si no hay mensaje para mostrar.
                    }
                  },
                ),

                // Muestra la regla para el nivel actual si es válido
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Centra los elementos en la fila

                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        barajaNotifier.reglaActual,
                        style: const TextStyle(
                            fontFamily: 'Lexend',
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right:
                              20.0), // Ajusta el espacio alrededor de la imagen
                      child: SizedBox(
                        width: 40, // Ajusta el ancho de la imagen
                        height: 40, // Ajusta la altura de la imagen
                        child: Image.asset('assets/images/vasitojuego.png',
                            fit: BoxFit
                                .cover), // Usa BoxFit.cover para mantener la relación de aspecto
                      ),
                    ),
                  ],
                ),

                // Aquí agregas el Consumer para escuchar los cambios y mostrar el mensaje

                // Aquí utilizamos el spread operator para incluir condicionalmente un widget.
                if (jugadorDebeTomar != null) ...[
                  _buildJugadorDebeTomarWidget(jugadorDebeTomar),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildJugadorDebeTomarWidget(Player jugador) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(jugador.avatar),
          radius: 30,
        ),
        Text(
          jugador.name,
          style: const TextStyle(
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.white),
        ),
        Row(
          children: jugador.cartas.map((c) => _CartasJugadores(c)).toList(),
        ),
      ],
    );
  }

  Widget _buildCardBack(double widthCartaAbajo, double heightCartaAbajo) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: widthCartaAbajo,
        height: heightCartaAbajo,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          image: const DecorationImage(
            image: AssetImage('assets/images/cartas/carta.png'),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayingCard(
      my.Carta? carta, double cardWidth, double cardHeight, double scale) {
    if (carta == null) return Container(); // Opción para manejar cartas nulas

    Suit suit = _convertMySuitToPlayingCardSuit(carta.palo);
    CardValue value = _convertMyValueToPlayingCardValue(carta.valor);

    // Ahora usa cardWidth, cardHeight y scale que se pasan como parámetros
    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Transform.scale(
        scale: scale,
        child: PlayingCardView(card: PlayingCard(suit, value)),
      ),
    );
  }

  Widget _buildFinalCardContainer(
      double widthCartaAbajo, double heightCartaAbajo) {
    // Este método construirá el contenedor para la carta final.
    // Puedes personalizar la apariencia como quieras, aquí hay un ejemplo simple:
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: heightCartaAbajo,
        height: widthCartaAbajo,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: const DecorationImage(
            image: AssetImage('assets/images/cartas/cartafinal.png'),
          ),
        ),
      ),
    );
  }

  Widget _CartasJugadores(my.Carta? carta) {
    if (carta == null) return Container(); // Opción para manejar cartas nulas

    Suit suit = _convertMySuitToPlayingCardSuit(carta.palo);
    CardValue value = _convertMyValueToPlayingCardValue(carta.valor);

    double scale = 0.9; // Ajusta este valor según sea necesario

    return SizedBox(
      width: 50, // Ancho del contenedor
      height: 70, // Altura del contenedor
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

void voltearSiguienteCarta(WidgetRef ref, context) {

  var barajaNotifier = ref.read(barajaProvider.notifier);
  var jugadores = ref.read(playerProvider);
  var forzarCarta = ref.read(forzarCartaProvider.notifier).state;

  // Restablece el estado del mensaje y jugadorDebeTomar al inicio
  ref.read(mostrarMensajeCartaCoincideProvider.notifier).state = false;
  ref.read(jugadorDebeTomarProvider.notifier).state = null;

  // Verifica si la carta final ya ha sido volteada
  if (barajaNotifier.cartaFinalVolteada) {
    GoRouter.of(context).go('/cartafinal');
    return;
  }

  for (int nivel = barajaNotifier.cartasBocaAbajo.length - 1;
      nivel >= 0;
      nivel--) {
    for (int posicion = 0;
        posicion < barajaNotifier.cartasBocaAbajo[nivel].length;
        posicion++) {
      if (barajaNotifier.cartasBocaAbajo[nivel][posicion]) {
        var cartaVolteada = barajaNotifier.piramide[nivel][posicion];
        if (cartaVolteada != null) {
          barajaNotifier.voltearCartaEnPiramide(nivel, posicion, jugadores);

          bool hayCoincidencia = false;
          for (var jugador in jugadores) {
            for (var cartaJugador in jugador.cartas) {
              if (cartaVolteada.valor == cartaJugador.valor) {
                ref.read(jugadorDebeTomarProvider.notifier).state = jugador;
                hayCoincidencia = true;
                break; // Rompe el ciclo interno si encuentra coincidencia
              }
            }
            if (hayCoincidencia)
              break; // Rompe el ciclo externo si encuentra coincidencia
          }

          if (!hayCoincidencia) {
            if (forzarCarta) {
              barajaNotifier.reemplazarCartaEnPiramide(nivel, posicion);
            }
            // Muestra el mensaje solo si no hay coincidencias y se activó forzarCarta o no
            ref.read(mostrarMensajeCartaCoincideProvider.notifier).state = true;
          }

          return; // Salir después de voltear una carta.
        }
      }
    }
  }
}
