import 'package:piramjuego/config/constants/cards_types.dart';

class Carta {
  final Suit palo;
  final CardValue valor;
  bool estaBocaArriba;

  Carta(this.palo, this.valor, {this.estaBocaArriba = false});

  void voltear() {
    estaBocaArriba = !estaBocaArriba;
  }

  // Método copyWith para crear una nueva instancia con datos actualizados
  Carta copyWith({bool? estaBocaArriba}) {
    return Carta(
      palo,
      valor,
      estaBocaArriba: estaBocaArriba ?? this.estaBocaArriba,
    );
  }
}
