import 'package:confetti/confetti.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final confettiControllerProvider = StateNotifierProvider.autoDispose<ConfettiController, ConfettiController>(
  (ref) {
    final controller = ConfettiController(duration: const Duration(seconds: 3));
    ref.onDispose(controller.dispose);
    return controller;
  },
);