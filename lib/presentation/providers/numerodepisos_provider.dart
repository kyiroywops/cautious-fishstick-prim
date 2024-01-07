import 'package:flutter_riverpod/flutter_riverpod.dart';

final pisoProvider = StateProvider<int>((ref) {
  return 7; // Valor inicial por defecto de pisos
});
