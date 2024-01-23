// lib/presentation/screens/player_selection_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:piramjuego/infrastructure/models/player_models.dart';
import 'package:piramjuego/presentation/providers/gamemode_provider.dart';
import 'package:piramjuego/presentation/providers/player_provider.dart';

class PlayerSelectionScreen extends ConsumerStatefulWidget {
  @override
  _PlayerSelectionScreenState createState() => _PlayerSelectionScreenState();
}

class _PlayerSelectionScreenState extends ConsumerState<PlayerSelectionScreen> {
  int _selectedLives = 3; // Un valor por defecto para las vidas
  final TextEditingController _nameController = TextEditingController();
  String _selectedAvatar =
      'assets/images/avatars/avatar1.png'; // Ruta al avatar por defecto

  @override
  Widget build(BuildContext context) {
    List<Player> players = ref.watch(playerProvider);
    final gameMode = ref.watch(gameModeProvider.state).state;

    void _addPlayer() {
      if (players.length >= 30) {
        // Mostrar algún mensaje de error o deshabilitar el botón de agregar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pueden agregar más de 30 jugadores')),
        );
        return;
      }

      final String name = _nameController.text;
      if (name.isNotEmpty && _selectedAvatar.isNotEmpty) {
        ref.read(playerProvider.notifier).addPlayer(
              Player(
                  name: name, avatar: _selectedAvatar),
            );
        _nameController.clear();
        _selectedAvatar = 'assets/images/avatars/avatar1.png';
      }
    }

    // Cuando el usuario selecciona un número de vidas, actualizamos el estado local y el provider
    void _handleLifeSelection(int numLives) {
      setState(() {
        _selectedLives = numLives;
      });
    }

    void _removePlayer(int index) {
      ref.read(playerProvider.notifier).removePlayer(index);
    }

    final Size screenSize = MediaQuery.of(context).size;
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    bool _showAddedMessage = false;
    String _addedPlayerName = '';



    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          padding: EdgeInsets.only(
              left: 16), // Agrega padding a la izquierda del icono
        ), // Esto cambiará el color del botón de retroceso a blanco
        title: Text(
          'Arma tu grupo',
          style: TextStyle(
            fontWeight: FontWeight.w800, fontFamily: 'Lexend',
            color: Theme.of(context).colorScheme.background,

            // Aplica negrita al texto
            // Puedes añadir más estilos si lo deseas, como el tamaño de la fuente o el color
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(40, screenSize.height * 0.02, 40, screenSize.height * 0.1),
          
              child: Column(
                children: [
                 
               
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 35, 10, 0),
                      child: Container(
                        height: screenSize.height * 0.2, // Ajusta esta altura según tus necesidades
          
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7, // Ajusta según el diseño de tu UI
                            crossAxisSpacing: 10, // Espaciado horizontal
                            mainAxisSpacing: 10, // Espaciado vertical
                          ),
                          itemCount: 21, // Asume que tienes 20 avatares
                          itemBuilder: (context, index) {
                            String avatarAsset =
                                'assets/images/avatars/avatar${index + 1}.png';
                            bool isSelected = _selectedAvatar == avatarAsset;
                        
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedAvatar =
                                      avatarAsset; // Actualiza el avatar seleccionado
                                });
                              },
                              child: Container(
                                decoration: isSelected
                                    ? BoxDecoration(
                                        border: Border.all(
                                          color: Colors
                                              .orange, // Color del borde cuando está seleccionado
                                          width: 3, // Ancho del borde
                                        ),
                                        shape: BoxShape
                                            .circle, // Forma circular para el borde
                                      )
                                    : null,
                                child: ClipOval(
                                  child: Image.asset(
                                    avatarAsset,
                                    width: 80, // Ajusta el tamaño del avatar
                                    height: 80, // Ajusta el tamaño del avatar
                                    fit: BoxFit
                                        .cover, // Esto asegura que la imagen llene el ClipOval
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  
                  
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical:
                              8.0), // Agrega márgenes verticales si es necesario
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0,
                          vertical:
                              15.0), // Aumenta el padding para un container más grande
                      decoration: BoxDecoration(
                        color: Colors.black
                            .withOpacity(0.60), // Fondo negro para el container
                        borderRadius: BorderRadius.circular(
                            30), // Bordes redondeados para el container
                      ),
                      child: TextField(
                        controller: _nameController,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(
                              20), // Limita la longitud del input a 20 caracteres
                          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
                        ],
                        style: const TextStyle(
                            color: Colors.white), // Texto blanco para el input
                        cursorColor: Colors.white, // Color del cursor a blanco
                        decoration: InputDecoration(
                          hintText: 'Nombre del jugador',
                          hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontFamily: 'Lexend',
                              fontWeight:
                                  FontWeight.w500), // Hint en blanco con opacidad
                          border: InputBorder.none, // Sin borde
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              vertical:
                                  10),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.add_circle_rounded, color: Colors.white),
                            onPressed: players.length >= 20 ? null : _addPlayer,
                          ), // Padding vertical para el texto dentro del input
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.03),
          
                 
                  
                
          
                  Center(
                    child: Text(
                      'Listado de Jugadores',
                      style: TextStyle(
                        fontFamily: 'Lexend',
                        color: Theme.of(context).colorScheme.background,
                        fontWeight:
                            FontWeight.w700, // Si deseas que el texto esté en negrita
                        fontSize:
                            24, // Puedes ajustar el tamaño según tus necesidades
                        // Otros estilos si son necesarios
                      ),
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.03),
          
                  
                    Container(
                      height: screenSize.height * 0.4,
                      child: ListView.builder(
                        itemCount: players
                            .length, // Usar la longitud de la lista obtenida del provider
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(players[index].avatar),
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                players[index].name,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            // Icono para eliminar jugadores
                            trailing: IconButton(
                              icon: Icon(Icons.remove_circle, color: Color(0xffFF414D)),
                              onPressed: () {
                                // Llama a la función para eliminar este jugador específico
                                _removePlayer(index);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  
                ],
              ),
            ),
          ),
                isKeyboardVisible 
                ? SizedBox.shrink()
                :
                  Positioned(
                    right: screenSize.width * 0.05,
                    bottom: screenSize.height * 0.05,
                  
                  
                  
                  
                                 
                    
                    child: ElevatedButton.icon(
                      onPressed: () {
                            ref.read(playerProvider.notifier);
                            
                          // Opcional: Imprimir la información de los jugadores
                          final updatedPlayers = ref.read(playerProvider);
                          for (var player in updatedPlayers) {
                            print('Jugador: ${player.name}');
                          }
                            
                          // Navegar a la pantalla de reglas
                          gameMode == GameMode.custom
                              ? GoRouter.of(context).go('/parametros')
                              : GoRouter.of(context).go('/cartasasignadas');
                        
                      },
                  icon: Icon(Icons.play_arrow, color: Colors.white),
                                label: Text('Jugar', style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.05, // 5% del ancho de la pantalla
                    vertical: screenSize.height * 0.01, // 1% del alto de la pantalla
                  ),
                  textStyle: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                       ),
                    ),
                  ),
                
        ],
      ),
    );
  }
}

