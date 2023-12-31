import 'package:piramjuego/infrastructure/models/carta_model.dart';

class Player {
  final String name;
  final String avatar;
  int lives;
  List<Carta> cartas; // Arreglo para almacenar las cartas asignadas al jugador

  Player({
    required this.name,
    required this.avatar,
    required this.lives,
    List<Carta>? cartas,
  }) : cartas = cartas ?? []; // Inicializa con una lista vacía si no se proporciona

  Player copyWith({String? name, String? avatar, int? lives, List<Carta>? cartas}) {
    return Player(
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      lives: lives ?? this.lives,
      cartas: cartas ?? this.cartas,
    );
  }
}
