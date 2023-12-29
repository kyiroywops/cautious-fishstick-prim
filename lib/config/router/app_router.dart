import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:piramjuego/presentation/screens/home_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
        builder: (BuildContext context, GoRouterState state) => PlayerSelectionScreen(),
        


    ),


  ]




);
