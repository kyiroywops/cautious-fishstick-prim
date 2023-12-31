import 'dart:math';

class ReglaFila {
  int piso;
  int sorbosTomar;
  int sorbosRegalar;

  ReglaFila({required this.piso, required this.sorbosTomar, required this.sorbosRegalar});

  // Método estático para generar las reglas basadas en la lógica que describes
  static List<ReglaFila> generarReglas(int numeroDePisos) {
    List<ReglaFila> reglas = [];
    int sorbosVasoCompleto = 100;

    for (int i = 0; i < numeroDePisos; i++) {
      int sorbos = pow(2, numeroDePisos - i - 1).toInt(); // Calcula los sorbos a tomar
      reglas.add(ReglaFila(piso: i + 1, sorbosTomar: sorbos, sorbosRegalar: sorbos * 2));
    }

    // El primer piso siempre toma todo el vaso, asumiendo que tomar todo el vaso es un valor predefinido
    reglas[0] = ReglaFila(piso: 1, sorbosTomar: sorbosVasoCompleto, sorbosRegalar: 0);

    return reglas;
  }
}
