import 'package:confetti/confetti.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final confettiControllerProvider = StateProvider.autoDispose<ConfettiController>((ref) {
  final controller = ConfettiController(duration: const Duration(seconds: 6));
  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});