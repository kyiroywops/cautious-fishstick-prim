import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:piramjuego/presentation/providers/barajascantidad_provider.dart';
import 'package:piramjuego/presentation/providers/cartasporjugador_provider.dart';
import 'package:piramjuego/presentation/providers/forzarcarta_provider.dart';
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

    // Colores para los switches
    Color switchActiveColor = Colors.black;
    Color switchInactiveTrackColor = Colors.white.withOpacity(0.7);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        leading: BotonAtras(),
        actions: [
          Container(
            margin: EdgeInsets.only(
                right: 8), // Espacio entre el contenedor y el botón de Discord
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.brown.withOpacity(0.8),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              gameMode == GameMode.custom ? 'Personalizada' : 'Rápida',
              style: TextStyle(color:Colors.white,  fontFamily: 'Lexend')
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
            _buildCustomSwitchListTile(
              title: 'Sorbos x2',
              value: ref.watch(sorbosX2Provider.state).state,
              onChanged: (newValue) {
                ref.read(sorbosX2Provider.state).state = newValue;
              },
            ),
            _buildCustomSwitchListTile(
              title: 'Forzar Carta',
              value: ref.watch(forzarCartaProvider.state).state,
              onChanged: (newValue) {
                ref.read(forzarCartaProvider.state).state = newValue;
              },
            ),
      


        
      
          Padding(
            padding: const EdgeInsets.all(15.0),
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
                onPressed: () =>
                    ref.read(cartasPorJugadorProvider.state).state = value,
                style: ElevatedButton.styleFrom(
                  primary: cartasPorJugador == value ? Colors.black : Colors.white,
                  onPrimary: Colors.white, // Color del texto cuando el botón está seleccionado
                  textStyle: TextStyle(
                    color: cartasPorJugador == value ? Colors.white : Colors.black, // Color del texto
                              fontFamily: 'Lexend',
                             fontWeight: FontWeight.w600,
                  ),
                  padding: EdgeInsets.all(20),
                ),
                child: Text(
                  value.toString(),
                  style: TextStyle(
                    color: cartasPorJugador == value ? Colors.white : Colors.black, // Color del texto
                  ),
                ),
              );
            }).toList(),
          ),

            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Cantidad de barajas',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
           Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 1; i <= 2; i++) // Para 1 y 2 barajas
                    _buildBarajasButton(i, ref),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 3; i <= 4; i++) // Para 3 y 4 barajas
                    _buildBarajasButton(i, ref),
                ],
              ),
            ],
          ), 
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Cantidad de pisos piramide',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
           Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [6, 7].map((int value) {
                  return _buildPisosButton(value, ref);
                }).toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [8, 10].map((int value) {
                  return _buildPisosButton(value, ref);
                }).toList(),
              ),
            ],
          ),
          ],
        ),
      ),
    
          
        
      
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(15.0),

        child: FloatingActionButton.extended(
        onPressed: () {
          // Navegar a la pantalla de reglas
          GoRouter.of(context).go('/cartasasignadas');
        },
        label: Text(
          'Siguiente',
          style: TextStyle(
            color: Colors.black, // Texto negro
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w600,
          ),
        ),
        icon: Icon(
          Icons.arrow_forward,
          color: Colors.black, // Ícono negro
        ),
        backgroundColor: Colors.white, // Fondo blanco
            ),
      ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
  );
}
      
  
}

  Widget _buildBarajasButton(int numero, WidgetRef ref) {
    final numeroBarajas = ref.watch(numeroBarajasProvider.state);
    String texto = numero > 1 ? '$numero Barajas' : '$numero Baraja';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () => numeroBarajas.state = numero,
        style: ElevatedButton.styleFrom(
          primary: numeroBarajas.state == numero ? Colors.black : Colors.white,
          onPrimary: Colors.white,
          textStyle: TextStyle(
            color: numeroBarajas.state == numero ? Colors.white : Colors.black,
          ),
          padding: EdgeInsets.all(20),
        ),
        child: Text(
          texto,
          style: TextStyle(
            color: numeroBarajas.state == numero ? Colors.white : Colors.black,
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w600,

          ),
        ),
      ),
    );
  }


Widget _buildPisosButton(int i, WidgetRef ref) {
  final numerodePisos = ref.watch(pisoProvider.state);
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ElevatedButton(
      onPressed: () => numerodePisos.state = i,
      style: ElevatedButton.styleFrom(
        primary: numerodePisos.state == i ? Colors.black : Colors.white,
        onPrimary: Colors.white, // Color del texto cuando el botón está seleccionado
        textStyle: TextStyle(
          color: numerodePisos.state == i ? Colors.white : Colors.black, // Color del texto
          fontFamily: 'Lexend',
          fontWeight: FontWeight.w600,
        ),
        padding: EdgeInsets.all(20),
      ),
      child: Text(
        '$i Pisos',
        style: TextStyle(
          color: numerodePisos.state == i ? Colors.white : Colors.black, // Color del texto
        ),
      ),
    ),
  );
}

  Widget _buildCustomSwitchListTile({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontFamily: 'Lexend', fontWeight: FontWeight.w700),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.white,
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: Colors.black,
      activeTrackColor: Colors.black,
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.black; // Color del thumb cuando está activado
        }
        return Colors.white; // Color del thumb cuando está desactivado
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.white; // Color del track cuando está activado
        }
        return Colors.black; // Color del track cuando está desactivado
      }),
    );
  }