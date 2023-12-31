import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:piramjuego/presentation/screens/cartas_asignadas_screen.dart';
import 'package:piramjuego/presentation/screens/category_screen.dart';
import 'package:piramjuego/presentation/screens/parametros_screen.dart';
import 'package:piramjuego/presentation/screens/seleccion_jugadores.dart';
import 'package:piramjuego/presentation/screens/inicial_home_screen.dart';
import 'package:piramjuego/presentation/screens/introductions_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
        builder: (BuildContext context, GoRouterState state) => InicialHomeScreen(),
        


    ),
    GoRoute(
      path: '/playerselection',
        builder: (BuildContext context, GoRouterState state) => PlayerSelectionScreen(),
        


    ),
     GoRoute(
      path: '/parametros',
        builder: (BuildContext context, GoRouterState state) => GamesScreen(),
      
        


    ),
     GoRoute(
      path: '/instructions',
        builder: (BuildContext context, GoRouterState state) => InstructionsScreen(),
      
        


    ),

    GoRoute(
      path: '/cartasasignadas',
        builder: (BuildContext context, GoRouterState state) => cartasAsignadasScreen(),
    ),

    GoRoute(
      path: '/questions',
      builder: (BuildContext context, GoRouterState state) {
        // Obtenemos la categoría pasada como parámetro extra.
        final category = state.extra as String;
        // Luego, pasamos esta categoría a la pantalla correspondiente.
        return QuestionsScreen(category: category);
      },
    ),


  ]




);
