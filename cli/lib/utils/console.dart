import 'dart:developer';

import 'package:ansicolor/ansicolor.dart';

final AnsiPen alertPen = AnsiPen()..xterm(001);
final AnsiPen infoPen = AnsiPen()..yellow();

void alert(String message, {String name = 'HYPEN CLI'}) =>
    log(alertPen('[$name] $message'));
void info(String message, {String name = 'HYPEN CLI'}) =>
    log(infoPen('[$name] $message'));
