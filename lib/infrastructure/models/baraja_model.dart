import 'dart:math';
import 'package:piramjuego/config/constants/cards_types.dart';

import 'carta_model.dart';

class Baraja {
  List<Carta> cartas = [];

  Baraja({bool incluirComodines = false}) {
    // Añadir cartas normales
    Suit.values.where((suit) => suit != Suit.none).forEach((palo) {
      CardValue.values
          .where((valor) =>
              valor != CardValue.joker_1 && valor != CardValue.joker_2)
          .forEach((valor) {
        cartas.add(Carta(palo, valor));
      });
    });

    // Añadir comodines si es necesario
    if (incluirComodines) {
      cartas.add(Carta(Suit.none,
          CardValue.joker_1)); // Utiliza Suit.none para los comodines.
      cartas.add(Carta(Suit.none, CardValue.joker_2));
    }
  }

  void barajar() {
    cartas.shuffle(Random());
  }

  Carta sacarCarta() {
    if (cartas.isNotEmpty) {
      Carta carta = cartas.last; // Obtiene la última carta
      print("Carta sacada: $carta");
      cartas.removeLast(); // Remueve la última carta
      return carta;
    } else {
      throw Exception('No hay más cartas en la baraja');
    }
  }

}
