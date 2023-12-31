class ConfiguracionJuego {
  int numeroDePisos;
  int numeroDeBarajas;
  bool cartaAdicionalParaRegalar;
  List<ReglaFila> reglasPorFila;

  ConfiguracionJuego({
    this.numeroDePisos = 3,
    this.numeroDeBarajas = 1,
    this.cartaAdicionalParaRegalar = false,
    List<ReglaFila>? reglasPorFila,
  }) : reglasPorFila = reglasPorFila ?? ReglaFila.reglasDefault(numeroDePisos);
}

class ReglaFila {
  int tomar;
  int regalar;

  ReglaFila({required this.tomar, required this.regalar});

  // Método estático para generar reglas predeterminadas
  static List<ReglaFila> reglasDefault(int numeroDePisos) {
    return List.generate(numeroDePisos, (index) {
      // Puedes definir la lógica para las reglas predeterminadas aquí.
      // Por ejemplo, tomar y regalar podrían ser iguales al número de la fila.
      return ReglaFila(tomar: index + 1, regalar: index + 1);
    });
  }
}
