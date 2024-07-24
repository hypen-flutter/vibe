import 'package:ansicolor/ansicolor.dart';

final alertPen = AnsiPen()..xterm(001);
final infoPen = AnsiPen()..yellow();

void alert(String message, {String name = 'HYPEN CLI'}) =>
    print(alertPen('[$name] $message'));
void info(String message, {String name = 'HYPEN CLI'}) =>
    print(infoPen('[$name] $message'));
