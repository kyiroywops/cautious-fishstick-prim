import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameSettingsNotifier extends StateNotifier<GameSettings> {
  GameSettingsNotifier() : super(GameSettings());

  void setCardCountPerPlayer(int count) {
    state = state.copyWith(cardCountPerPlayer: count);
  }

  void setPyramidLevels(int levels) {
    state = state.copyWith(pyramidLevels: levels);
  }

  // ... más métodos para cada parámetro ...
}

class GameSettings {
  final int cardCountPerPlayer;
  final int pyramidLevels;
  // ... más campos para cada parámetro ...

  GameSettings({
    this.cardCountPerPlayer = 3,
    this.pyramidLevels = 3,
    // ... valores por defecto para cada parámetro ...
  });

  GameSettings copyWith({int? cardCountPerPlayer, int? pyramidLevels /*, más parámetros */}) {
    return GameSettings(
      cardCountPerPlayer: cardCountPerPlayer ?? this.cardCountPerPlayer,
      pyramidLevels: pyramidLevels ?? this.pyramidLevels,
      // ... copiar más parámetros ...
    );
  }
}
