import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part './theme_event.dart';
part './theme_states.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(ThemeMode.system)) {
    on<LoadThemeEvent>(_onLoadTheme);
    on<ToggleThemeEvent>(_onToggleTheme);
  }

  Future<void> _onLoadTheme(
    LoadThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('themeMode') ?? 0;
    emit(ThemeState(ThemeMode.values[themeIndex]));
  }

  Future<void> _onToggleTheme(
    ToggleThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final newMode = state.themeMode == ThemeMode.dark 
        ? ThemeMode.light 
        : ThemeMode.dark;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', newMode.index);
    
    emit(ThemeState(newMode));
  }
}
