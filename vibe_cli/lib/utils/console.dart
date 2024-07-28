// ignore_for_file: avoid_print

import 'package:ansicolor/ansicolor.dart';

final AnsiPen alertPen = AnsiPen()..xterm(001);
final AnsiPen infoPen = AnsiPen()..yellow();

void alert(String message, {String name = 'Vibe CLI'}) =>
    print(alertPen('[$name] $message'));
void info(String message, {String name = 'Vibe CLI'}) =>
    print(infoPen('[$name] $message'));
