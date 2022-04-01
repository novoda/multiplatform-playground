import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news/features/frontpage/presentation/screens/front_page.dart';

import 'dependencies_injection.dart' as di;

void main() async {
  await dotenv.load(fileName: ".secrets_env");
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Your News',
      home: FrontPage(),
    );
  }
}
