import 'package:flutter/material.dart';
import 'screens/warehouse_statistics_page.dart'; // Import your page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  //   @override
  //   Widget build(BuildContext context) {
  //     return MaterialApp(
  //       title: 'Flutter Demo',
  //       theme: ThemeData(
  //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  //       ),
  //       home: const MyHomePage(title: 'Flutter Demo Home Page'),
  //     );
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warehouse App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WarehouseStatisticsPage(), // Show this page by default
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  static const Color takhzinPrimary = Color(0xFFCF1D51);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Takhzin App',
      theme: ThemeData(
        primaryColor: takhzinPrimary,
        scaffoldBackgroundColor: Color(0xFFF9FAFB),
        appBarTheme: AppBarTheme(
          backgroundColor: takhzinPrimary,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: takhzinPrimary,
          primary: takhzinPrimary,
        ),
      ),
      home: WarehouseStatisticsPage(),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       backgroundColor: Color(0xFFCF1D51), // Takhzin navbar color
  //       elevation: 3,
  //       centerTitle: true,
  //       title: Row(
  //         children: [
  //           Icon(Icons.warehouse, color: Colors.white),
  //           SizedBox(width: 12),
  //           Text(
  //             'Warehouse Statistics',
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontSize: 20,
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //     body: Center(
  //       // Center is a layout widget. It takes a single child and positions it
  //       // in the middle of the parent.
  //       child: Column(
  //         // Column is also a layout widget. It takes a list of children and
  //         // arranges them vertically. By default, it sizes itself to fit its
  //         // children horizontally, and tries to be as tall as its parent.
  //         //
  //         // Column has various properties to control how it sizes itself and
  //         // how it positions its children. Here we use mainAxisAlignment to
  //         // center the children vertically; the main axis here is the vertical
  //         // axis because Columns are vertical (the cross axis would be
  //         // horizontal).
  //         //
  //         // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
  //         // action in the IDE, or press "p" in the console), to see the
  //         // wireframe for each widget.
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           const Text('You have pushed the button this many times:'),
  //           Text(
  //             '$_counter',
  //             style: Theme.of(context).textTheme.headlineMedium,
  //           ),
  //         ],
  //       ),
  //     ),
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: _incrementCounter,
  //       tooltip: 'Increment',
  //       child: const Icon(Icons.add),
  //     ), // This trailing comma makes auto-formatting nicer for build methods.
  //   );
  // }
}
