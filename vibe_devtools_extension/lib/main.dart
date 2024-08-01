import 'package:devtools_app_shared/service.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';

void main() async {
  final ServiceManager serviceManager = ServiceManager();
  serviceManager.connectedState.addListener(() {});
  // Access isolates.
  final _ = serviceManager.isolateManager.mainIsolate.value;
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DevToolsExtension(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 30,
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text('State History'),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 150,
                    child: ListView(
                      children: [
                        ListTile(
                          onTap: () {},
                          title: const Text("KEY"),
                        )
                      ],
                    ),
                  ),
                  const VerticalDivider(),
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          onTap: () {},
                          title: const Text("Set to HISTORY"),
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
    );
  }
}
