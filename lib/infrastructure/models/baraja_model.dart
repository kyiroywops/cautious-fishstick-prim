import 'dart:math';
import 'package:piramjuego/config/constants/cards_types.dart';
import 'carta_model.dart';

class Baraja {
  List<Carta> cartas = [];
  List<List<Carta?>> piramide;
  int numerodePisos;  // 'numerodePisos' con 'n' minúscula

  

  Baraja({
  List<Carta>? cartasPredefinidas,
  List<List<Carta?>>? piramideInicial,
  int numeroDeBarajas = 1,  // Nuevo parámetro para número de barajas
  this.numerodePisos = 7, 
  
}) : piramide = piramideInicial ?? List.generate(numerodePisos, (nivel) => List.filled(nivel + 1, null, growable: false)) {
  if (cartasPredefinidas != null) {
    cartas = cartasPredefinidas;
  } else {
    for (int i = 0; i < numeroDeBarajas; i++) {
      Suit.values.where((suit) => suit != Suit.none).forEach((palo) {
        CardValue.values.where((valor) => valor != CardValue.joker_1 && valor != CardValue.joker_2).forEach((valor) {
          cartas.add(Carta(palo, valor));
        });
      });
    }
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
// Método copyWith para crear una nueva instancia con datos actualizados
  Baraja copyWith({
    List<Carta>? nuevasCartas,
    List<List<Carta?>>? nuevaPiramide,
    int? numerodePisos,  // 'numerodePisos' con 'n' minúscula para que coincida
  }) {
    return Baraja(
      cartasPredefinidas: nuevasCartas ?? List<Carta>.from(cartas),
      piramideInicial: nuevaPiramide ?? List<List<Carta?>>.from(piramide),
      numeroDeBarajas: 1,  // Asegúrate de proporcionar un valor predeterminado aquí si es necesario
      numerodePisos: numerodePisos ?? this.numerodePisos,  // 'numerodePisos' con 'n' minúscula
    );
  }
}