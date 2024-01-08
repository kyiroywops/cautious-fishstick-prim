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

    final double cardWidth = numeroDePisos > 7 ? 40 : 50;
    final double cardHeight = numeroDePisos > 7 ? 50 : 70;
    final double cardScale = numeroDePisos > 7 ? 1 : 1;

    final double widthCartaAbajo = numeroDePisos > 7 ? 30 : 35;
    final double heightCartaAbajo = numeroDePisos > 7 ? 50 : 55;

    Future<bool> _onWillPop() async {
      bool shouldPop = (await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Salir',
                  style: TextStyle(
                      fontFamily: 'Lexend', fontWeight: FontWeight.w600)),
              content: Text(
                  'Si sales ahora, la partida se reiniciará. ¿Quieres salir?',
                  style: TextStyle(
                      fontFamily: 'Lexend', fontWeight: FontWeight.w500)),
              actions: <Widget>[
                TextButton(
                  child: Text('No',
                      style: TextStyle(
                          fontFamily: 'Lexend', fontWeight: FontWeight.w800)),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: Text('Sí',
                      style: TextStyle(
                          fontFamily: 'Lexend', fontWeight: FontWeight.w600)),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            ),
          )) ??
          false;

      return shouldPop;
    }

    print("Reconstruyendo JuegoPiramideScreen con estado actualizado");
    

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        leading: Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 23),
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
                                    cardWidth, cardHeight, cardScale)
                                  
                                    
                                    ),

                                          if (nivel == 0) Padding(
                                            
                                          padding: const EdgeInsets.only(right: 50),
                                            child: _buildFinalCardContainer(widthCartaAbajo, heightCartaAbajo),
                                          ),

                    ],
                  ),
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context)
                          .colorScheme
                          .surfaceVariant
                          .withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () => voltearSiguienteCarta(ref, context),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Voltear Carta',
                        style: TextStyle(
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),

                // Aquí agregas el Consumer para escuchar los cambios y mostrar el mensaje
                Consumer(
                  builder: (context, ref, child) {
                    final mostrarMensaje = ref.watch(mostrarMensajeCartaCoincideProvider);
                    if (mostrarMensaje) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Nadie tiene esa carta, presiona el botón de nuevo",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      );
                    } else {
                      return Container(); // Devuelve un contenedor vacío si no hay mensaje para mostrar.
                    }
                  },
                ),


                // Muestra la regla para el nivel actual si es válido
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    barajaNotifier.reglaActual,
                    style: TextStyle(
                        fontFamily: 'Lexend',
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
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
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(jugador.avatar),
            radius: 30,
          ),
          Text(
            jugador.name,
            style: TextStyle(
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.white),
          ),
          Row(
            children: jugador.cartas.map((c) => _CartasJugadores(c)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack(double widthCartaAbajo, double heightCartaAbajo) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: widthCartaAbajo,
        height: heightCartaAbajo,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
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
    return Container(
      width: cardWidth,
      height: cardHeight,
      child: Transform.scale(
        scale: scale,
        child: PlayingCardView(card: PlayingCard(suit, value)),
      ),
    );
  }

  Widget _buildFinalCardContainer(double widthCartaAbajo, double heightCartaAbajo) {
    // Este método construirá el contenedor para la carta final.
    // Puedes personalizar la apariencia como quieras, aquí hay un ejemplo simple:
   return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: heightCartaAbajo,
        height: widthCartaAbajo,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
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

    double scale = 1; // Ajusta este valor según sea necesario

    return Container(
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
  print("Voltear siguiente carta llamado");

  var barajaNotifier = ref.read(barajaProvider.notifier);
  var jugadores = ref.read(playerProvider);
  var forzarCarta = ref.read(forzarCartaProvider.state).state;

  // Restablece el estado del mensaje y jugadorDebeTomar al inicio
  ref.read(mostrarMensajeCartaCoincideProvider.state).state = false;
  ref.read(jugadorDebeTomarProvider.notifier).state = null;

   // Verifica si la carta final ya ha sido volteada
  if (barajaNotifier.cartaFinalVolteada) {
    print("La última carta ya ha sido volteada. Navegando a la pantalla final.");
    GoRouter.of(context).go('/cartafinal');
    return;
  }


  for (int nivel = barajaNotifier.cartasBocaAbajo.length - 1; nivel >= 0; nivel--) {
    for (int posicion = 0; posicion < barajaNotifier.cartasBocaAbajo[nivel].length; posicion++) {
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
            if (hayCoincidencia) break; // Rompe el ciclo externo si encuentra coincidencia
          }

          if (!hayCoincidencia) {
            if (forzarCarta) {
              barajaNotifier.reemplazarCartaEnPiramide(nivel, posicion);
            }
            // Muestra el mensaje solo si no hay coincidencias y se activó forzarCarta o no
            ref.read(mostrarMensajeCartaCoincideProvider.state).state = true;
          }

          return; // Salir después de voltear una carta.
        }
      }
    }
  }
  print("No se encontraron cartas boca abajo");
}