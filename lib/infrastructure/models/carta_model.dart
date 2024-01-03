// carta_model.dart
import 'package:piramjuego/config/constants/cards_types.dart';

class Carta {
  final Suit palo;
  final CardValue valor;

  Carta(this.palo, this.valor);

  @override
  String toString() {
    return '$valor de $palo';
  }
}
