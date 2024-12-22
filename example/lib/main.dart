import 'package:animated_text_lerp/animated_text_lerp.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _texts = ["Orange", "Apple", "PineApple", "Pizza"];

  int _val = 0;
  int _stringIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _stringIndex = _stringIndex++;
                  if (_stringIndex >= _texts.length) {
                    _stringIndex = 0;
                  }
                });
              },
              child: const Text("New Text"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _val += 100;
                });
              },
              child: const Text("New Num"),
            ),
            AnimatedNumberText(
              _val, // int or double
              curve: Curves.easeIn,
              duration: const Duration(seconds: 1),
              style: const TextStyle(fontSize: 30),
              formatter: (value) {
                final formatted =
                    intl.NumberFormat.currency(locale: "en").format(value);
                return formatted;
              },
            ),
            AnimatedStringText(
              _texts[_stringIndex], // int or double
              curve: Curves.easeIn,
              duration: const Duration(seconds: 1),
              style: const TextStyle(fontSize: 30),
            )
          ],
        ),
      ),
    );
  }
}
