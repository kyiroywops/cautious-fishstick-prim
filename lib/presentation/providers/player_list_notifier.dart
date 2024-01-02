// Definición de PlayerListNotifier
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piramjuego/infrastructure/models/carta_model.dart';
import 'package:piramjuego/infrastructure/models/player_models.dart';

class PlayerListNotifier extends StateNotifier<List<Player>> {
  PlayerListNotifier() : super([]);

  void addPlayer(Player player) {
    state = [...state, player];
  }

  void removePlayer(int index) {
    state = [...state]..removeAt(index);
  }

    // Método para asignar cartas a todos los jugadores
  void asignarCartas(List<Carta> cartasAsignadas) {
    state = [
      for (final jugador in state)
        jugador.copyWith(cartas: cartasAsignadas),
    ];
  }



  





}

// player_provider.dart
final playerProvider = StateNotifierProvider<PlayerListNotifier, List<Player>>((ref) {
  return PlayerListNotifier();
});