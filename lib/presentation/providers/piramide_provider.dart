import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piramjuego/infrastructure/models/baraja_model.dart';
import 'package:piramjuego/infrastructure/models/carta_model.dart';
import 'package:piramjuego/presentation/providers/baraja_provider.dart';

final piramideProvider = StateNotifierProvider<BarajaNotifier, Baraja>(
  (ref) => ref.read(barajaProvider.notifier),
);