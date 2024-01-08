// Define un StateProvider para el jugador que debe tomar
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piramjuego/infrastructure/models/player_models.dart';

final jugadorDebeTomarProvider = StateProvider.autoDispose<Player?>((ref) => null);
