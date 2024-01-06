import 'dart:math';
import 'package:piramjuego/config/constants/cards_types.dart';
import 'carta_model.dart';

class Baraja {
  List<Carta> cartas = [];
  List<List<Carta?>> piramide;

  

  Baraja({
    List<Carta>? cartasPredefinidas,
    List<List<Carta?>>? piramideInicial,
  }) : piramide = piramideInicial ?? List.generate(7, (nivel) => List.filled(nivel + 1, null, growable: false)) {
    if (cartasPredefinidas != null) {
      this.cartas = cartasPredefinidas;
    } else {
      Suit.values.where((suit) => suit != Suit.none).forEach((palo) {
        CardValue.values.where((valor) => valor != CardValue.joker_1 && valor != CardValue.joker_2).forEach((valor) {
          cartas.add(Carta(palo, valor));
        });
      });

     
    }
  }

  void barajar() {
    cartas.shuffle(Random());
  }

  Carta sacarCarta() {
    if (cartas.isNotEmpty) {
      Carta carta = cartas.removeLast();
      return carta;
    } else {
      throw Exception('No hay más cartas en la baraja');
    }
  }

  // Método copyWith para crear una nueva instancia con datos actualizados
  Baraja copyWith({
    List<Carta>? nuevasCartas,
    List<List<Carta?>>? nuevaPiramide,
  }) {
    return Baraja(
      cartasPredefinidas: nuevasCartas ?? List<Carta>.from(cartas),
      piramideInicial: nuevaPiramide ?? List<List<Carta?>>.from(piramide),
    );
  }
}
