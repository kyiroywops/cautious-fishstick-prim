import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piramjuego/infrastructure/models/baraja_model.dart';
import 'package:piramjuego/infrastructure/models/carta_model.dart';
import 'package:piramjuego/infrastructure/models/player_models.dart'; // Asegúrate de importar tu modelo de Player

class BarajaNotifier extends StateNotifier<Baraja> {
  BarajaNotifier() : super(Baraja());

  void generarYBarajarMazo() {
    state = Baraja();
    state.barajar();
  }

  Carta sacarCarta() {
    return state.sacarCarta();
  }

  void asignarCartas(List<Player> jugadores, int cartasPorJugador) {
    for (var jugador in jugadores) {
      jugador.cartas.clear(); // Limpia las cartas actuales

      for (int i = 0; i < cartasPorJugador; i++) {
        try {
          jugador.cartas.add(sacarCarta()); // Asigna nuevas cartas
        } catch (e) {
          // Manejar el caso en que no haya suficientes cartas en el mazo
          // Por ejemplo, podrías detener el proceso de asignación o manejar de otra manera
        }
      }
    }
  }

  // ... cualquier otra lógica que necesites para gestionar el mazo
}

final barajaProvider = StateNotifierProvider<BarajaNotifier, Baraja>((ref) {
  return BarajaNotifier();
});