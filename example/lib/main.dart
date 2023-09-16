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
        padding: const EdgeInsets.all(10.0),
        child: FlutterSpreadsheetUI(
          config: FlutterSpreadsheetUIConfig(pinnedFirstRow: true),
          columns: List.generate(
            10,
            (index) => FlutterSpreadsheetUIColumn<String>(
              value: (index).toString(),
              builder: (
                BuildContext context,
                CellIndex cellIndex,
                data,
              ) {
                return Center(
                    child: Text('Col : $cellIndex\nColumnData: $data'));
              },
            ),
          ),
          rows: List.generate(
            10,
            (index) => FlutterSpreadsheetUIRow<String>(
              value: (index).toString(),
              builder: (
                BuildContext context,
                CellIndex cellIndex,
                data,
              ) {
                return Center(child: Text('Row : $cellIndex\nRowData: $data'));
              },
            ),
          ),
        ),
      ),
    );
  }
}
