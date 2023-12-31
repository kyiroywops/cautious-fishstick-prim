// game_settings_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piramjuego/infrastructure/models/configuracion_juego_model.dart';
import 'package:piramjuego/infrastructure/models/regla_fila.dart';

class GameSettingsNotifier extends StateNotifier<ConfiguracionJuego> {
  GameSettingsNotifier() : super(ConfiguracionJuego());

  void actualizarNumeroDePisos(int numeroDePisos) {
    state = state.copyWith(
      numeroDePisos: numeroDePisos,
      reglasPorFila: ReglaFila.generarReglas(numeroDePisos),
    );
  }

  void actualizarNumeroDeBarajas(int numeroDeBarajas) {
    state = state.copyWith(numeroDeBarajas: numeroDeBarajas);
  }

  void actualizarCartaAdicionalParaRegalar(bool cartaAdicionalParaRegalar) {
    state = state.copyWith(cartaAdicionalParaRegalar: cartaAdicionalParaRegalar);
  }

  // Agrega aquí métodos para actualizar otras configuraciones si es necesario
}

final gameSettingsProvider = StateNotifierProvider<GameSettingsNotifier, ConfiguracionJuego>((ref) {
  return GameSettingsNotifier();
});
