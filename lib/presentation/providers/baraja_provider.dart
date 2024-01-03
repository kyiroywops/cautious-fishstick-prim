import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piramjuego/infrastructure/models/baraja_model.dart';
import 'package:piramjuego/infrastructure/models/carta_model.dart';
import 'package:piramjuego/infrastructure/models/player_models.dart';

class BarajaNotifier extends StateNotifier<Baraja> {
  BarajaNotifier() : super(Baraja());

  void generarYBarajarMazo() {
    state = Baraja();
    state.barajar();
    print("Mazo generado y barajado: ${state.cartas}");
  }

  Carta sacarCarta() {
    if (state.cartas.isNotEmpty) {
      // Obtiene la carta del final de la lista de cartas.
      Carta carta = state.cartas.last;
      print("Carta sacada: $carta");

      // Remueve la carta del mazo.
      state.cartas.removeLast();

      return carta;
    } else {
      // Si no hay cartas, lanza una excepción.
      throw Exception('No hay más cartas en la baraja');
    }
  }

  void asignarCartas(List<Player> jugadores, int cartasPorJugador) {
    print("Asignando cartas a los jugadores");

    generarYBarajarMazo();
    print("Generado");

    print("Número de jugadores: ${jugadores.length}");
    if (jugadores.isEmpty) {
      print("No hay jugadores para asignar cartas.");
      return;
    }

    for (var jugador in jugadores) {
      List<Carta> cartasAsignadas = [];
      for (int i = 0; i < cartasPorJugador; i++) {
        cartasAsignadas.add(sacarCarta());
      }
      jugador.cartas = cartasAsignadas;
      print(
          "Cartas asignadas a ${jugador.name}: ${cartasAsignadas.map((c) => c.toString()).join(', ')}");
    }
  }

  List<List<Carta?>> piramide = [];
  List<Carta> cartasRestantes = [];

  void iniciarJuegoPiramide() {
    generarYBarajarMazo();
    state.barajar();
    final int totalNiveles = 7;

    

    piramide = List.generate(
        totalNiveles, (nivel) => List.filled(nivel + 1, null, growable: false));
    cartasRestantes.clear();

    for (int nivel = 0; nivel < totalNiveles; nivel++) {
      for (int posicion = 0; posicion <= nivel; posicion++) {
        if (state.cartas.isNotEmpty) {
          piramide[nivel][posicion] = state.sacarCarta();
        }
      }
    }

    cartasRestantes.addAll(state.cartas);
    state = Baraja(cartasPredefinidas: cartasRestantes);

  }

  List<Carta> cartasVolteadas = [];


void voltearCartaEnPiramide(int nivel, int posicion) {
  if (nivel < piramide.length && posicion < piramide[nivel].length) {
    var carta = piramide[nivel][posicion];
    if (carta != null && !cartasVolteadas.contains(carta)) {
      cartasVolteadas.add(carta);
      // Aquí actualizas la carta en la pirámide si es necesario

      // Luego, si necesitas actualizar el estado para reflejar cambios en la UI:
      state = Baraja(cartasPredefinidas: cartasRestantes);
    }
  }
}
}

// Al final del archivo
final barajaProvider = StateNotifierProvider<BarajaNotifier, Baraja>((ref) {
  return BarajaNotifier();
});
