import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:piramjuego/infrastructure/models/carta_model.dart';
import 'package:piramjuego/infrastructure/models/player_models.dart';
import 'package:piramjuego/presentation/providers/baraja_provider.dart';
import 'package:piramjuego/presentation/providers/player_provider.dart';

class FinalScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtiene la carta final actual y la lista de jugadores
    final barajaNotifier = ref.watch(barajaProvider.notifier);
    final jugadores = ref.watch(playerProvider);
    final cartaFinal = barajaNotifier.cartaFinal;

    return Scaffold(
      backgroundColor: Colors.black, // Fondo de pantalla beige
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(70.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/vasofinal.png', // Ruta de tu imagen
                width: 200, // Ancho de la imagen
                height: 200, // Altura de la imagen
              ),
              SizedBox(height: 20), // Espacio entre imagen y texto
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'La proxima carta es la carta final, toma al seco.',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              SizedBox(height: 20), // Espacio entre texto y botón
              ElevatedButton(
                onPressed: () => _onVoltearCartaPressed(
                    context, ref),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Fondo negro
                  foregroundColor: Colors.black, // Texto en blanco
                ),
                child: Text(
                  'Voltear carta',
                  style: TextStyle(
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildFinalCardContainer() {
  // Este método construirá el contenedor para la carta final.
  // Puedes personalizar la apariencia como quieras, aquí hay un ejemplo simple:
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: 55,
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: AssetImage('assets/images/cartas/cartafinal.png'),
        ),
      ),
    ),
  );
}

  void _onVoltearCartaPressed(BuildContext context, WidgetRef ref) {
    final barajaNotifier = ref.read(barajaProvider.notifier);
    final jugadores = ref.read(playerProvider);

    Player? jugadorCoincidente = encontrarJugadorCoincidente(jugadores, barajaNotifier.cartaFinal);

    // Si no hay coincidencia, asigna una nueva carta final
    if (jugadorCoincidente == null && barajaNotifier.cartaFinal != null) {
      do {
        barajaNotifier.asignarCartaFinal(jugadores);
        jugadorCoincidente = encontrarJugadorCoincidente(jugadores, barajaNotifier.cartaFinal);
      } while (jugadorCoincidente == null);
    }

    // Navega a la pantalla de resultado con los parámetros necesarios
    if (jugadorCoincidente != null && barajaNotifier.cartaFinal != null) {
      GoRouter.of(context).go('/resultadofinal', extra: {
      'cartaFinal': barajaNotifier.cartaFinal,
      'jugador': jugadorCoincidente
    });
      // Considera cómo manejarás el 'jugador' en la pantalla de resultado
    }
  }

  Player? encontrarJugadorCoincidente(List<Player> jugadores, Carta? cartaFinal) {
    if (cartaFinal == null) return null;
    for (var jugador in jugadores) {
      if (jugador.cartas.any((carta) => carta.valor == cartaFinal.valor)) {
        return jugador;
      }
    }
    return null;
  }
