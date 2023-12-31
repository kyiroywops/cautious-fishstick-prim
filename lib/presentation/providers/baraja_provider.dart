// baraja_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piramjuego/infrastructure/models/baraja_model.dart';
import 'package:piramjuego/infrastructure/models/carta_model.dart';

class BarajaNotifier extends StateNotifier<Baraja> {
  BarajaNotifier() : super(Baraja());

  void barajar() {
    state.barajar();
    state = state; // Notifica a los oyentes del cambio
  }

  Carta sacarCarta() {
    return state.sacarCarta();
  }
}

final barajaProvider = StateNotifierProvider<BarajaNotifier, Baraja>((ref) {
  return BarajaNotifier();
});
