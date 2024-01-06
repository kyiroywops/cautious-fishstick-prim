import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
    

    Future<bool> _onWillPop() async {
    bool shouldPop = (await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
         
            title: Text('Salir', style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w600)),
            content: Text('Si sales ahora, la partida se reiniciará. ¿Quieres salir?', style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w500)),
            actions: <Widget>[
              TextButton(
                child: Text('No', style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w800)),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: Text('Sí', style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w600)),
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
                      for (int posicion = 0; posicion < piramide[nivel].length; posicion++)
                        InkWell(
                          child: cartasBocaAbajo[nivel][posicion]
                              ? _buildCardBack()
                              : _buildPlayingCard(piramide[nivel][posicion])
                        ),
                    ],
                  ),
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () => voltearSiguienteCarta(ref),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Voltear Carta', style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w600, color: Colors.white),),
                    ),
                  ),
                ),
                 // Muestra la regla para el nivel actual si es válido
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(barajaNotifier.reglaActual, style: TextStyle(fontFamily: 'Lexend', color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),),
                  ),
             
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
          Text(jugador.name, style: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white
          ),),
          Row(
            children: jugador.cartas.map((c) => _buildPlayingCard(c)).toList(),
          ),
        ],
      ),
    );
  }



  Widget _buildCardBack() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 35,
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: AssetImage('assets/images/cartas/carta.png'),
          ),
        ),
      ),
    );
  }


  Widget _buildPlayingCard(my.Carta? carta) {
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




