import 'package:flutter/cupertino.dart';
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

    List<bool> isSelected = [2, 3, 4, 5].map((e) => e == cartasPorJugador).toList();

    final numeroBarajas = ref.watch(numeroBarajasProvider.state).state;
    List<bool> isSelectedBarajas = [1, 2, 3, 4].map((e) => e == numeroBarajas).toList();

    final numerodePisos = ref.watch(pisoProvider.state).state;
    List<bool> isSelectedPisos = [6, 7, 8, 10].map((e) => e == numerodePisos).toList();




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
        padding: const EdgeInsets.fromLTRB(40, 10, 40, 40),
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
          Padding(
  padding: const EdgeInsets.all(15.0),
  child: Container(
    decoration: BoxDecoration(
      color: Colors.grey.shade300, // Fondo general gris para los botones
      borderRadius: BorderRadius.circular(8.0), // Bordes redondeados para el contenedor
    ),
    child: ToggleButtons(
      borderColor: Colors.transparent,
      fillColor: Colors.yellow.shade600, // Color de fondo cuando está seleccionado
      borderWidth: 1,
      selectedBorderColor: Colors.transparent,
      borderRadius: BorderRadius.circular(8.0), // Bordes redondeados para cada botón
      children: <Widget>[
            _buildToggleButton('2', isSelected[0]),
            _buildToggleButton('3', isSelected[1]),
            _buildToggleButton('4', isSelected[2]),
            _buildToggleButton('5', isSelected[3]),
          ],
          onPressed: (int index) {
            // Ajusta el valor directamente al valor del botón
            ref.read(cartasPorJugadorProvider.state).state = index + 2;
            for (int i = 0; i < isSelected.length; i++) {
              isSelected[i] = i == index;
            }
            // Puede que esta línea no sea necesaria si tu estado se actualiza correctamente
            (context as Element).markNeedsBuild();
          },
          isSelected: isSelected,
        ),
      ),
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
           Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ToggleButtons(
          borderColor: Colors.transparent,
          fillColor: Colors.yellow.shade600,
          borderWidth: 1,
          selectedBorderColor: Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
          children: <Widget>[
            _buildToggleButton('1', isSelectedBarajas[0]),
            _buildToggleButton('2', isSelectedBarajas[1]),
            _buildToggleButton('3', isSelectedBarajas[2]),
            _buildToggleButton('4', isSelectedBarajas[3]),
          ],
          onPressed: (int index) {
            ref.read(numeroBarajasProvider.state).state = index + 1;
            for (int i = 0; i < isSelectedBarajas.length; i++) {
              isSelectedBarajas[i] = i == index;
            }
            (context as Element).markNeedsBuild();
          },
          isSelected: isSelectedBarajas,
        ),
      ),
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
             Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ToggleButtons(
          borderColor: Colors.transparent,
          fillColor: Colors.yellow.shade600,
          borderWidth: 1,
          selectedBorderColor: Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
          children: <Widget>[
            _buildToggleButton('6', isSelectedPisos[0]),
            _buildToggleButton('7', isSelectedPisos[1]),
            _buildToggleButton('8', isSelectedPisos[2]),
            _buildToggleButton('10', isSelectedPisos[3]),
          ],
          onPressed: (int index) {
            ref.read(pisoProvider.state).state = [6, 7, 8, 10][index];
            for (int i = 0; i < isSelectedPisos.length; i++) {
              isSelectedPisos[i] = i == index;
            }
            (context as Element).markNeedsBuild();
          },
          isSelected: isSelectedPisos,
        ),
      ),
    ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20.0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade300, // Color de fondo del contenedor
            borderRadius: BorderRadius.circular(15.0),
            border: Border(
              left: BorderSide(
                color: Colors.orange, // Color del borde izquierdo
                width: 5.0, // Ancho del borde izquierdo
              ),
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Text(
                        '¡Peligro!',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Lexend',
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Ten cuidado al aumentar el número de cartas, asegúrate de tener suficientes barajas para que el juego funcione correctamente.',
                        style: TextStyle(
                          color: Colors.black54,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w700,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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


   Widget _buildToggleButton(String title, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Lexend',
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: isSelected ? Colors.black : Colors.grey, // Cambiar el color del texto según el estado
        ),
      ),
    );
  }
