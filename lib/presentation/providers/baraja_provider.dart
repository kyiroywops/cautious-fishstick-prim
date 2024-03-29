import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piramjuego/infrastructure/models/baraja_model.dart';
import 'package:piramjuego/infrastructure/models/carta_model.dart';
import 'package:piramjuego/infrastructure/models/player_models.dart';

class BarajaNotifier extends StateNotifier<Baraja> {
  int numerodePisos;
  bool forzarCarta = false; // Añade un campo para forzar la carta

  BarajaNotifier()
      : numerodePisos = 7,
        super(Baraja());

  // Añadimos una lista para rastrear el estado de si las cartas están boca abajo.
  List<List<bool>> cartasBocaAbajo =
      List.generate(7, (nivel) => List.filled(nivel + 1, true));

  bool tieneCoincidencia(Carta cartaVolteada, List<Player> jugadores) {
    for (var jugador in jugadores) {
      for (var cartaJugador in jugador.cartas) {
        if (cartaVolteada.valor == cartaJugador.valor) {
          return true;
        }
      }
    }
    return false;
  }

    // Método para resetear el juego a su estado inicial
  void resetearJuego() {
    // Limpia la lista de cartas volteadas y la pirámide
    cartasVolteadas.clear();
    piramide.clear();
    cartasRestantes.clear();

    // Restablece las cartas boca abajo y la carta final
    cartasBocaAbajo = List.generate(7, (nivel) => List.filled(nivel + 1, true));
    cartaFinal = null;
    cartaFinalVolteada = false;
    reglaActual = '';

    // Restablece la baraja al estado inicial
    state = Baraja(cartasPredefinidas: [], piramideInicial: []);

    // Notifica a los oyentes del cambio de estado para que la UI se actualice
    reconstruir.value = !reconstruir.value;
  }


  void reemplazarCartaEnPiramide(int nivel, int posicion) {
    if (nivel < piramide.length && posicion < piramide[nivel].length) {
      Carta nuevaCarta = sacarCarta();
      piramide[nivel][posicion] = nuevaCarta;
      cartasBocaAbajo[nivel][posicion] =
          true; // La nueva carta estará boca abajo inicialmente

      // Notificar a los observadores del cambio en el estado.
      state = Baraja(
          cartasPredefinidas: List<Carta>.from(state.cartas),
          piramideInicial: List<List<Carta?>>.from(
              piramide.map((nivel) => List<Carta?>.from(nivel))));
    }
  }

  Carta? cartaFinal; // Añade esto como un campo en la clase BarajaNotifier

  void generarYAsignarCartas(List<Player> jugadores, int cartasPorJugador,
      bool sorbosX2, int numerodebarajas, int numerodePisos) {
    generarYBarajarMazo(numerodebarajas);
    asignarCartasAJugadores(jugadores, cartasPorJugador);
    asignarCartaFinal(jugadores);
    iniciarJuegoPiramide(sorbosX2, numerodePisos);
  }

List<Player> encontrarJugadoresCoincidentes(Carta cartaFinal, List<Player> jugadores) {
  List<Player> jugadoresCoincidentes = [];

  for (var jugador in jugadores) {
    if (jugador.cartas.any((carta) => carta.valor == cartaFinal.valor)) {
      jugadoresCoincidentes.add(jugador);
    }
  }

  return jugadoresCoincidentes;
}

void asignarCartaFinal(List<Player> jugadores) {
  Carta nuevaCartaFinal;
  List<Player> jugadoresCoincidentes;

  do {
    if (state.cartas.isEmpty) {
      throw Exception('No hay más cartas en la baraja');
    }

    nuevaCartaFinal = sacarCarta();

    jugadoresCoincidentes = encontrarJugadoresCoincidentes(nuevaCartaFinal, jugadores);

  } while (jugadoresCoincidentes.isEmpty);

  cartaFinal = nuevaCartaFinal;
  
  // Notifica a los observadores del cambio en el estado de la carta final.
  state = Baraja(
    cartasPredefinidas: List<Carta>.from(state.cartas),
    piramideInicial: List<List<Carta?>>.from(
      piramide.map((nivel) => List<Carta?>.from(nivel))
    )
  );
}

  String reglaActual = ''; // Añade un campo para la regla actual

  void generarYBarajarMazo(int numeroDeBarajas) {
    state = Baraja(numeroDeBarajas: numeroDeBarajas);
    state.barajar();
  }

  Carta sacarCarta() {
    if (state.cartas.isNotEmpty) {
      // Obtiene la carta del final de la lista de cartas.
      Carta carta = state.cartas.last;

      // Remueve la carta del mazo.
      state.cartas.removeLast();

      return carta;
    } else {
      // Si no hay cartas, lanza una excepción.
      throw Exception('No hay más cartas en la baraja');
    }
  }

  void asignarCartasAJugadores(List<Player> jugadores, int cartasPorJugador) {


    if (jugadores.isEmpty) {
      return;
    }

    for (var jugador in jugadores) {
      List<Carta> cartasAsignadas = [];
      for (int i = 0; i < cartasPorJugador; i++) {
        cartasAsignadas.add(sacarCarta());
      }
      jugador.cartas = cartasAsignadas;
    }
  }

  

  List<List<Carta?>> piramide = [];
  List<Carta> cartasRestantes = [];

  void iniciarJuegoPiramide(bool sorbosX2, int numerodePisos) {
    generarReglas(numerodePisos, sorbosX2: sorbosX2);

    piramide = List.generate(numerodePisos,
        (nivel) => List.filled(nivel + 1, null, growable: false));
    cartasRestantes.clear();

    for (int nivel = 0; nivel < numerodePisos; nivel++) {
      for (int posicion = 0; posicion <= nivel; posicion++) {
        if (state.cartas.isNotEmpty) {
          piramide[nivel][posicion] = state.sacarCarta();
        }
      }
    }

    cartasRestantes.addAll(state.cartas);
    state = Baraja(cartasPredefinidas: cartasRestantes);

    cartasBocaAbajo =
        List.generate(numerodePisos, (nivel) => List.filled(nivel + 1, true));
  }

  List<Carta> cartasVolteadas = [];
  ValueNotifier<bool> reconstruir = ValueNotifier(false);
  bool cartaFinalVolteada =
      false; // Añade esto para rastrear el estado de la última carta

  void voltearCartaEnPiramide(int nivel, int posicion, List<Player> jugadores) {

    if (nivel < piramide.length && posicion < piramide[nivel].length) {
      var carta = piramide[nivel][posicion];
      if (carta != null && !cartasVolteadas.contains(carta)) {
        cartasVolteadas.add(carta);
        cartasBocaAbajo[nivel][posicion] = false;
        reglaActual = reglas[nivel];

        // Actualiza el estado de la carta directamente
        carta.voltear();

        if (carta == piramide[0][0]) {
          cartaFinalVolteada = true;
        }

        // Si forzarCarta está activo y no hay coincidencia, agregar una nueva carta a la misma posición
        if (forzarCarta && !tieneCoincidencia(carta, jugadores)) {
          Carta nuevaCarta =
              sacarCarta(); // Suponiendo que 'sacarCarta' devuelve una nueva carta
          piramide[nivel][posicion] = nuevaCarta;
        }

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

void generarReglas(int totalNiveles, {bool sorbosX2 = false}) {
  reglas = List.generate(totalNiveles, (nivel) {
    int cantidad = nivel + 1;
    if (sorbosX2) {
      cantidad *= 2; // Duplica la cantidad si sorbosX2 es verdadero
    }

    if (nivel == totalNiveles - 1) {
      // En el último nivel, personaliza la regla aquí.
      return "Regala un vaso al seco";
    } else {
      // Para otros niveles, sigue la lógica de "Regalas" o "Tomas"
      String accion = (totalNiveles - nivel) % 2 == 0 ? "Regalas" : "Tomas";
      String sorboPlural = cantidad == 1 ? "sorbo" : "sorbos";
      return "$accion $cantidad $sorboPlural";
    }
  }).reversed.toList();
}

// Al final del archivo
final barajaProvider = StateNotifierProvider<BarajaNotifier, Baraja>((ref) {
  return BarajaNotifier();
});
