import 'package:piramjuego/infrastructure/models/carta_model.dart';

class Player {
  final String name;
  final String avatar;
  List<Carta> cartas; // Arreglo para almacenar las cartas asignadas al jugador

  Player({
    required this.name,
    required this.avatar,
    List<Carta>? cartas,
  }) : cartas = cartas ?? []; // Inicializa con una lista vacía si no se proporciona

  Player copyWith({String? name, String? avatar, List<Carta>? cartas}) {
    return Player(
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      cartas: cartas ?? this.cartas,
    );
  }
}
