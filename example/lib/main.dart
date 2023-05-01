import 'package:flutter/material.dart';
import 'package:flutter_spreadsheet_ui/flutter_spreadsheet_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: FlutterSpreadsheetUI(
          config: const FlutterSpreadsheetUIConfig(
            freezedColumnWidth: 150,
          ),
          columns: List.generate(
            10,
            (_) => FlutterSpreadsheetUIColumn(
              cellBuilder: (context, cellId) => Text(cellId),
            ),
          ),
          rows: List.generate(
            15,
            (_) => FlutterSpreadsheetUIRow(
              cells: List.generate(
                10,
                (_) => FlutterSpreadsheetUICell(
                  cellBuilder: (context, cellId) => Text(cellId),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}