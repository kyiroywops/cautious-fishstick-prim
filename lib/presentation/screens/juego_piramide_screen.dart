import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piramjuego/config/constants/cards_types.dart' as my;
import 'package:piramjuego/infrastructure/models/carta_model.dart' as my;
import 'package:piramjuego/infrastructure/models/player_models.dart';
import 'package:piramjuego/presentation/providers/baraja_provider.dart';
import 'package:piramjuego/presentation/providers/jugadordebetomar_provider.dart';
import 'package:piramjuego/presentation/providers/player_provider.dart';
import 'package:playing_cards/playing_cards.dart';

class JuegoPiramideScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final barajaNotifier = ref.watch(barajaProvider.notifier);
    final jugadorDebeTomar = ref.watch(jugadorDebeTomarProvider);


      print("Reconstruyendo JuegoPiramideScreen con estado actualizado");


        return Scaffold(
      appBar: AppBar(title: Text('Juego de Pirámide')),
      body: ValueListenableBuilder<bool>(
        valueListenable: barajaNotifier.reconstruir,
        builder: (context, value, child) {
          // Usa 'value' si es necesario para tomar decisiones en la UI
          final piramide = barajaNotifier.piramide;
          final cartasBocaAbajo = barajaNotifier.cartasBocaAbajo;

          return Column(
            children: [
              for (int nivel = 0; nivel < piramide.length; nivel++)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int posicion = 0; posicion < piramide[nivel].length; posicion++)
                      InkWell(
                        child: cartasBocaAbajo[nivel][posicion]
                            ? _buildCardBack()
                            : _buildPlayingCard(piramide[nivel][posicion])
                      ),
                  ],
                ),
              ElevatedButton(
                onPressed: () => voltearSiguienteCarta(ref),
                child: Text('Voltear Carta'),
              ),
               // Aquí utilizamos el spread operator para incluir condicionalmente un widget.
          if (jugadorDebeTomar != null) ...[
            _buildJugadorDebeTomarWidget(jugadorDebeTomar),
          ],
        
 
            ],
            
          );
        },
      ),
    );
  }

    Widget _buildJugadorDebeTomarWidget(Player jugador) {
    return Container(
      color: Colors.grey[200], // Puedes elegir el color que prefieras
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(jugador.avatar),
          ),
          Text(jugador.name),
          Row(
            children: jugador.cartas.map((c) => _buildPlayingCard(c)).toList(),
          ),
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

    double scale = 1; // Ajusta este valor según sea necesario

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



// void voltearSiguienteCarta(WidgetRef ref) {
//     print("Voltear siguiente carta llamado");

  
//   var barajaNotifier = ref.read(barajaProvider.notifier);
//   // Itera sobre las cartas boca abajo y voltear la primera que encuentre
//   for (int nivel = barajaNotifier.cartasBocaAbajo.length - 1; nivel >= 0; nivel--) {
//     for (int posicion = 0; posicion < barajaNotifier.cartasBocaAbajo[nivel].length; posicion++) {
//       if (barajaNotifier.cartasBocaAbajo[nivel][posicion]) {
//           // Imprimir la regla para el nivel actual
//         print("Regla para nivel $nivel: ${reglas[nivel]}");

//         // Voltear la carta
//                 print("Encontrada carta boca abajo en nivel $nivel, posición $posicion");

//         barajaNotifier.voltearCartaEnPiramide(nivel, posicion);
//         return; // Salir después de voltear una carta
//       }
//     }
//   }
//     print("No se encontraron cartas boca abajo");

// }

void voltearSiguienteCarta(WidgetRef ref) {
  print("Voltear siguiente carta llamado");
  
  // Acceder al notificador de baraja y a la lista de jugadores.
  var barajaNotifier = ref.read(barajaProvider.notifier);
  var jugadores = ref.read(playerProvider);
  ref.read(jugadorDebeTomarProvider.notifier).state = null;


  // Iterar sobre las cartas boca abajo y voltear la primera que se encuentre.
  for (int nivel = barajaNotifier.cartasBocaAbajo.length - 1; nivel >= 0; nivel--) {
    for (int posicion = 0; posicion < barajaNotifier.cartasBocaAbajo[nivel].length; posicion++) {
      if (barajaNotifier.cartasBocaAbajo[nivel][posicion]) {
        // Imprimir la regla para el nivel actual
        print("Regla para nivel $nivel: ${reglas[nivel]}");

        // Voltear la carta y obtener su valor.
        print("Encontrada carta boca abajo en nivel $nivel, posición $posicion");
        var cartaVolteada = barajaNotifier.piramide[nivel][posicion];
        if (cartaVolteada != null) {
          barajaNotifier.voltearCartaEnPiramide(nivel, posicion);

          // Verificar si la carta volteada coincide con las cartas de los jugadores por valor.
          for (var jugador in jugadores) {
            for (var cartaJugador in jugador.cartas) {
               if (cartaVolteada.valor == cartaJugador.valor) {
                // Si hay una coincidencia, actualiza el estado con el jugador que debe tomar.
                ref.read(jugadorDebeTomarProvider.notifier).state = jugador;
                // ... más lógica si es necesario ...
              }

            }
          }
        }
        return; // Salir después de voltear una carta.
      }
    }
  }
  print("No se encontraron cartas boca abajo");
}



