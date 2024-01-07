import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:piramjuego/presentation/providers/barajascantidad_provider.dart';
import 'package:piramjuego/presentation/providers/cartasporjugador_provider.dart';
import 'package:piramjuego/presentation/providers/gamemode_provider.dart';
import 'package:piramjuego/presentation/providers/numerodepisos_provider.dart';
import 'package:piramjuego/presentation/providers/sorbos_provider.dart';
import 'package:piramjuego/presentation/widgets/boton_atras.dart';
import 'package:url_launcher/url_launcher.dart';

class GamesScreen extends ConsumerWidget {
  // URL de tu comunidad en Discord
  final String discordUrl = 'https://discord.gg/tuComunidad';

  // Método para abrir el enlace de Discord
  void _launchDiscord(BuildContext context) async {
    if (await canLaunch(discordUrl)) {
      await launch(discordUrl);
    } else {
      // Mostrar error o manejar la situación
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir el enlace de Discord')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameMode = ref.watch(gameModeProvider.state).state;
    final cartasPorJugador = ref.watch(cartasPorJugadorProvider.state).state;





    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.onBackground,
          leading: BotonAtras(),
          actions: [
            Container(
              margin: EdgeInsets.only(
                  right:
                      8), // Espacio entre el contenedor y el botón de Discord
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.brown.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                gameMode == GameMode.custom ? 'Personalizada' : 'Rápida',
                style: TextStyle(color: Colors.white, fontFamily: 'Lexend'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                icon: Icon(Icons.discord, color: Colors.white),
                onPressed: () => _launchDiscord(context),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
          child: Column(
            children: [
              Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text('Sorbos x2',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                 Switch(
                  value: ref.watch(sorbosX2Provider.state).state,
                  onChanged: (newValue) {
                      ref.read(sorbosX2Provider.state).state = newValue;
                  },
              )
                ],
              ),
            ),
             Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Cantidad de cartas por jugador',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [2, 3, 4].map((int value) {
                return ElevatedButton(
                  onPressed: () => ref.read(cartasPorJugadorProvider.state).state = value,
                  style: ElevatedButton.styleFrom(
                    primary: cartasPorJugador == value ? Colors.blue : Colors.grey,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                  ),
                  child: Text(
                    value.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),

             Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Cantidad de barajas',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 1; i <= 4; i++) // Para 1 a 4 barajas
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer(
                    builder: (context, ref, _) {
                      final numeroBarajas = ref.watch(numeroBarajasProvider.state);
                      return ElevatedButton(
                        onPressed: () => numeroBarajas.state = i,
                        style: ElevatedButton.styleFrom(
                          primary: numeroBarajas.state == i ? Colors.blue : Colors.grey,
                        ),
                        child: Text('$i Barajas'),
                      );
                    },
                  ),
                ),
            ],
          ),
              Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Cantidad de pisos piramide',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 6; i <= 9; i++) // Para 1 a 4 barajas
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer(
                    builder: (context, ref, _) {
                      final numerodePisos = ref.watch(pisoProvider.state);
                      return ElevatedButton(
                        onPressed: () => numerodePisos.state = i,
                        style: ElevatedButton.styleFrom(
                          primary: numerodePisos.state == i ? Colors.blue : Colors.grey,
                        ),
                        child: Text('$i Pisos'),
                      );
                    },
                  ),
                ),
            ],
          ),



              Padding(
                padding: const EdgeInsets.all(60.0),
                child: ElevatedButton(
                onPressed: () {
                
                  // Navegar a la pantalla de reglas
                  GoRouter.of(context).go('/cartasasignadas');
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Empezar partida',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w600), // Letra blanca
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color(0xffFF414D).withOpacity(0.85), // Fondo negro
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Bordes redondeados
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 44, vertical: 10), // Padding interior del botón
                ),
                            ),
              )
            ],
          ),
        ),
        );
  }
}
