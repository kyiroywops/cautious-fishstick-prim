import 'package:piramjuego/infrastructure/models/regla_fila.dart';

class ConfiguracionJuego {
  final int numeroDePisos;
  final int numeroDeBarajas;
  final bool cartaAdicionalParaRegalar;
  final List<ReglaFila> reglasPorFila;

  ConfiguracionJuego({
    this.numeroDePisos = 7,
    this.numeroDeBarajas = 1,
    this.cartaAdicionalParaRegalar = false,
    List<ReglaFila>? reglasPorFila,
  }) : reglasPorFila = reglasPorFila ?? ReglaFila.generarReglas(numeroDePisos);

  // Método copyWith para clonar el objeto con pequeñas modificaciones
  ConfiguracionJuego copyWith({
    int? numeroDePisos,
    int? numeroDeBarajas,
    bool? cartaAdicionalParaRegalar,
    List<ReglaFila>? reglasPorFila,
  }) {
    return ConfiguracionJuego(
      numeroDePisos: numeroDePisos ?? this.numeroDePisos,
      numeroDeBarajas: numeroDeBarajas ?? this.numeroDeBarajas,
      cartaAdicionalParaRegalar: cartaAdicionalParaRegalar ?? this.cartaAdicionalParaRegalar,
      reglasPorFila: reglasPorFila ?? this.reglasPorFila,
    );
  }
}
