import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piramjuego/infrastructure/models/baraja_model.dart';
import 'package:piramjuego/infrastructure/models/carta_model.dart';
import 'package:piramjuego/infrastructure/models/player_models.dart';

class BarajaNotifier extends StateNotifier<Baraja> {

  
  // Añadimos una lista para rastrear el estado de si las cartas están boca abajo.
  List<List<bool>> cartasBocaAbajo =
      List.generate(7, (nivel) => List.filled(nivel + 1, true));

  BarajaNotifier() : super(Baraja());

  void generarYAsignarCartas(List<Player> jugadores, int cartasPorJugador) {
    generarYBarajarMazo();
    asignarCartasAJugadores(jugadores, cartasPorJugador);
    iniciarJuegoPiramide();
  }


  

  void generarYBarajarMazo() {
    state = Baraja();
    state.barajar();
    print("Mazo generado y barajado: ${state.cartas}");
  }

  Carta sacarCarta() {
    if (state.cartas.isNotEmpty) {
      // Obtiene la carta del final de la lista de cartas.
      Carta carta = state.cartas.last;
      print("Carta sacada: $carta");

      // Remueve la carta del mazo.
      state.cartas.removeLast();

      return carta;
    } else {
      // Si no hay cartas, lanza una excepción.
      throw Exception('No hay más cartas en la baraja');
    }
  }

  void asignarCartasAJugadores(List<Player> jugadores, int cartasPorJugador) {
    print("Asignando cartas a los jugadores");

    generarYBarajarMazo();
    print("Generado");

    print("Número de jugadores: ${jugadores.length}");
    if (jugadores.isEmpty) {
      print("No hay jugadores para asignar cartas.");
      return;
    }

    for (var jugador in jugadores) {
      List<Carta> cartasAsignadas = [];
      for (int i = 0; i < cartasPorJugador; i++) {
        cartasAsignadas.add(sacarCarta());
      }
      jugador.cartas = cartasAsignadas;
      print(
          "Cartas asignadas a ${jugador.name}: ${cartasAsignadas.map((c) => c.toString()).join(', ')}");
    }
  }

  List<List<Carta?>> piramide = [];
  List<Carta> cartasRestantes = [];

  void iniciarJuegoPiramide() {
    const int totalNiveles = 7;
    generarReglas(totalNiveles);


    piramide = List.generate(
        totalNiveles, (nivel) => List.filled(nivel + 1, null, growable: false));
    cartasRestantes.clear();

    for (int nivel = 0; nivel < totalNiveles; nivel++) {
      for (int posicion = 0; posicion <= nivel; posicion++) {
        if (state.cartas.isNotEmpty) {
          piramide[nivel][posicion] = state.sacarCarta();
        }
      }
    }

    cartasRestantes.addAll(state.cartas);
    state = Baraja(cartasPredefinidas: cartasRestantes);

    cartasBocaAbajo = List.generate(7, (nivel) => List.filled(nivel + 1, true));
  }

  List<Carta> cartasVolteadas = [];
  ValueNotifier<bool> reconstruir = ValueNotifier(false);



  void voltearCartaEnPiramide(int nivel, int posicion) {
    print("Intentando voltear carta en nivel $nivel, posición $posicion");

    if (nivel < piramide.length && posicion < piramide[nivel].length) {
      var carta = piramide[nivel][posicion];
      if (carta != null && !cartasVolteadas.contains(carta)) {
        print("Volteando carta: $carta");
        cartasVolteadas.add(carta);
        cartasBocaAbajo[nivel][posicion] = false;

        // Actualiza el estado de la carta directamente
        carta.voltear();

        // Actualiza las listas de cartas y pirámide directamente
        piramide[nivel][posicion] = carta;
        state = Baraja(
            cartasPredefinidas: List<Carta>.from(state.cartas),
            piramideInicial: List<List<Carta?>>.from(
                piramide.map((nivel) => List<Carta?>.from(nivel))));
      }
        reconstruir.value = !reconstruir.value;

    }
  }
}

late List<String> reglas; // Inicializa la lista de reglas

// Método para generar reglas basadas en el total de niveles
void generarReglas(int totalNiveles) {
  reglas = List.generate(totalNiveles, (nivel) {
    // Determinar si el nivel es par o impar desde la base de la pirámide
    bool esPar = (totalNiveles - nivel - 1) % 2 == 0;
    int cantidad = totalNiveles - nivel;

    if (nivel == totalNiveles) {
      return "Tomar todo"; // Regla para el último nivel (base de la pirámide)
    }
    return esPar ? "Tomar $cantidad" : "Regalar $cantidad";
  }).reversed.toList();
}

// Al final del archivo
final barajaProvider = StateNotifierProvider<BarajaNotifier, Baraja>((ref) {
  return BarajaNotifier();
});
