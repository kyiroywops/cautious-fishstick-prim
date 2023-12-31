import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:piramjuego/infrastructure/models/game_models.dart';
import 'package:piramjuego/presentation/providers/gamemode_provider.dart';
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
    int _selectedLives = 3;



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
                child: Text('Cantidad de pisos',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w700)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  int numLives = index + 6;
                  bool isSelected = numLives == _selectedLives;
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: isSelected
                            ? Colors.orange
                            : Color(
                                0xFF46383b), // Cambia el color si está seleccionado
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: isSelected
                            ? 10
                            : 5, // Elevación más pronunciada si está seleccionado
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        side: isSelected
                            ? BorderSide(
                                color: Colors.orangeAccent,
                                width: 2) // Borde si está seleccionado
                            : null,
                      ),
                      onPressed: () {
                      // Esto es solo para fines de visualización por ahora
                      print('Número de vidas seleccionadas: $numLives');
                      // Aquí se conectará la lógica de estado más adelante
                    },
                      // ...
                      child: Text(
                        '$numLives 🃏',
                        style: TextStyle(
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : Colors.grey[
                                  200], // Cambia el color del texto si está seleccionado
                        ),
                      ),
                    ),
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('El piso final',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w700)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  int numLives = index + 1;
                  bool isSelected = numLives == _selectedLives;
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: isSelected
                            ? Colors.orange
                            : Color(
                                0xFF46383b), // Cambia el color si está seleccionado
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: isSelected
                            ? 10
                            : 5, // Elevación más pronunciada si está seleccionado
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        side: isSelected
                            ? BorderSide(
                                color: Colors.orangeAccent,
                                width: 2) // Borde si está seleccionado
                            : null,
                      ),
                      onPressed: () {
                      // Esto es solo para fines de visualización por ahora
                      print('Número de vidas seleccionadas: $numLives');
                      // Aquí se conectará la lógica de estado más adelante
                    },
                      // ...
                      child: Text(
                        '$numLives 🃏',
                        style: TextStyle(
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : Colors.grey[
                                  200], // Cambia el color del texto si está seleccionado
                        ),
                      ),
                    ),
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('Cantidad de sorbos por ronda',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w700)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(2, (index) {
                  int numLives = index + 1;
                  bool isSelected = numLives == _selectedLives;
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: isSelected
                            ? Colors.orange
                            : Color(
                                0xFF46383b), // Cambia el color si está seleccionado
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: isSelected
                            ? 10
                            : 5, // Elevación más pronunciada si está seleccionado
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        side: isSelected
                            ? BorderSide(
                                color: Colors.orangeAccent,
                                width: 2) // Borde si está seleccionado
                            : null,
                      ),
                      onPressed: () {
                      // Esto es solo para fines de visualización por ahora
                      print('Número de vidas seleccionadas: $numLives');
                      // Aquí se conectará la lógica de estado más adelante
                    },
                      // ...
                      child: Text(
                        '$numLives 🃏',
                        style: TextStyle(
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : Colors.grey[
                                  200], // Cambia el color del texto si está seleccionado
                        ),
                      ),
                    ),
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('Sorbos primera ronda',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w700)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  int numLives = index + 1;
                  bool isSelected = numLives == _selectedLives;
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: isSelected
                            ? Colors.orange
                            : Color(
                                0xFF46383b), // Cambia el color si está seleccionado
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: isSelected
                            ? 10
                            : 5, // Elevación más pronunciada si está seleccionado
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        side: isSelected
                            ? BorderSide(
                                color: Colors.orangeAccent,
                                width: 2) // Borde si está seleccionado
                            : null,
                      ),
                      onPressed: () {
                      // Esto es solo para fines de visualización por ahora
                      print('Número de vidas seleccionadas: $numLives');
                      // Aquí se conectará la lógica de estado más adelante
                    },
                      // ...
                      child: Text(
                        '$numLives 🃏',
                        style: TextStyle(
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : Colors.grey[
                                  200], // Cambia el color del texto si está seleccionado
                        ),
                      ),
                    ),
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('Incluir Jokers en la baraja',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w700)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(2, (index) {
                  int numLives = index + 1;
                  bool isSelected = numLives == _selectedLives;
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: isSelected
                            ? Colors.orange
                            : Color(
                                0xFF46383b), // Cambia el color si está seleccionado
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: isSelected
                            ? 10
                            : 5, // Elevación más pronunciada si está seleccionado
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        side: isSelected
                            ? BorderSide(
                                color: Colors.orangeAccent,
                                width: 2) // Borde si está seleccionado
                            : null,
                      ),
                      onPressed: () {
                      // Esto es solo para fines de visualización por ahora
                      print('Número de vidas seleccionadas: $numLives');
                      // Aquí se conectará la lógica de estado más adelante
                    },
                      // ...
                      child: Text(
                        '$numLives 🃏',
                        style: TextStyle(
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : Colors.grey[
                                  200], // Cambia el color del texto si está seleccionado
                        ),
                      ),
                    ),
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('Pirámide invertida',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w700)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(2, (index) {
                  int numLives = index + 1;
                  bool isSelected = numLives == _selectedLives;
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: isSelected
                            ? Colors.orange
                            : Color(
                                0xFF46383b), // Cambia el color si está seleccionado
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: isSelected
                            ? 10
                            : 5, // Elevación más pronunciada si está seleccionado
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        side: isSelected
                            ? BorderSide(
                                color: Colors.orangeAccent,
                                width: 2) // Borde si está seleccionado
                            : null,
                      ),
                      onPressed: () {
                      // Esto es solo para fines de visualización por ahora
                      print('Número de vidas seleccionadas: $numLives');
                      // Aquí se conectará la lógica de estado más adelante
                    },
                      // ...
                      child: Text(
                        '$numLives 🃏',
                        style: TextStyle(
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : Colors.grey[
                                  200], // Cambia el color del texto si está seleccionado
                        ),
                      ),
                    ),
                  );
                }),
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
