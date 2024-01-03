// Definición de PlayerListNotifier
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piramjuego/infrastructure/models/player_models.dart';

class PlayerListNotifier extends StateNotifier<List<Player>> {
  PlayerListNotifier() : super([]);

  void addPlayer(Player player) {
    state = [...state, player];
  }

  void removePlayer(int index) {
    state = [...state]..removeAt(index);
  }



    // Método para actualizar la lista de jugadores
  void setPlayers(List<Player> updatedPlayers) {
      state = List.from(updatedPlayers); // Crea una nueva instancia de la lista

  }



  





}

// player_provider.dart
final playerProvider = StateNotifierProvider<PlayerListNotifier, List<Player>>((ref) {
  return PlayerListNotifier();
});