import 'package:flutter_riverpod/flutter_riverpod.dart';

final forzarCartaProvider = StateProvider<bool>((ref) {
  return false; // El valor inicial será false, indicando que no se fuerza la carta por defecto.
});