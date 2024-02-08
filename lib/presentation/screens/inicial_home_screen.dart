import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:piramjuego/presentation/providers/gamemode_provider.dart';
import 'package:piramjuego/presentation/widgets/boton_discord.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';



class InicialHomeScreen extends ConsumerStatefulWidget {
  @override
  _InicialHomeScreenState createState() => _InicialHomeScreenState();
}

class _InicialHomeScreenState extends ConsumerState<InicialHomeScreen> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/images/videos/video.mp4')
      ..initialize().then((_) {
        _controller!.play();
        _controller!.setLooping(true);
        setState(() {});
      });
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Video de fondo
          _controller?.value.isInitialized ?? false
              ? FittedBox(
                  fit: BoxFit
                      .cover, // Esto asegura que el video cubra el espacio disponible
                child: SizedBox(
                    width: _controller!.value.size.width,
                    height: _controller!.value.size.height,
                    child: VideoPlayer(_controller!),
                  ),
                )
              : Container(color: Theme.of(context).colorScheme.onBackground),
          // Contenido de la aplicación
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(screenSize.width * 0.1),
                        child: Center(
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: screenSize.width * 0.4,
                            height: screenSize.height * 0.3,
                            fit: BoxFit.contain,
                          ),
                        )
                      ),
                      _buildButton(context, 'Partida rápida', GameMode.quick,
                          screenSize),
                      _buildButton(context, 'Partida personalizada',
                          GameMode.custom, screenSize),
                      // Dentro de tu Column, reemplaza la llamada a _buildButton para "Cómo jugar" con esto:
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.2,
                          vertical: screenSize.height * 0.02,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            GoRouter.of(context).push('/instructions');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.90), // Color de fondo del botón
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30), // Bordes redondeados
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 10,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Cómo jugar',
                              style: TextStyle(
                                color: Colors.black, // Color del texto
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w800,
                                fontSize: screenSize.width * 0.035,
                              ),
                            ),
                          ),
                        ),
                      ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center, // Centrar los íconos en el Row
                        children: <Widget>[
                        IconButton(
                          icon: const Icon(FontAwesomeIcons.instagram, color: Colors.white),
                          onPressed: () => _launchURL('https://www.instagram.com/piramideapp'),
                        ),
                          const SizedBox(width: 20), // Espacio entre los íconos
                          IconButton(
                            icon: const Icon(Icons.discord, color: Colors.white,),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return DiscordDialog(discordUrl: 'https://discord.gg/EHqWWN59'); // Coloca aquí tu URL de Discord
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20), // Espacio entre los íconos y el texto
                      const Text(
                        'Recuerda beber con moderación.',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w300,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Text(
                        '© Derechos reservados Tryagain.',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w200,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    String text,
    GameMode mode,
    Size screenSize, {
    bool isBlack = true,
    Color textColor = Colors
        .white, // Añadido parámetro para el color del texto con valor por defecto blanco
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.2,
        vertical: screenSize.height * 0.02,
      ),
      child: ElevatedButton(
        onPressed: () {
          ref.read(gameModeProvider.notifier).state = mode;
          GoRouter.of(context).push('/playerselection');
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: TextStyle(
              color: textColor, // Usamos el parámetro textColor aquí
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w800,
              fontSize: screenSize.width * 0.035,
            ),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isBlack
              ? Colors.black.withOpacity(0.85)
              : Colors.white.withOpacity(0.90),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 10,
          ),
        ),
      ),
    );
  }
}
