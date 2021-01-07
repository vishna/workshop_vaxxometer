import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<http.Response> fetchData() {
  return http.get('https://rki-vaccination-data.vercel.app/api');
}

class VaccineStatus {
  const VaccineStatus(
      {this.total,
      this.vaccinated,
      this.difference_to_the_previous_day,
      this.quote});
  final int total;
  final int vaccinated;
  final int difference_to_the_previous_day;
  final double quote;

  factory VaccineStatus.fromJson(Map<String, dynamic> json) {
    return VaccineStatus(
      total: json['total'],
      vaccinated: json['vaccinated'],
      difference_to_the_previous_day: json['difference_to_the_previous_day'],
      quote: json['quote'],
    );
  }
}

void main() {
  fetchData().then((value) => print(value.body));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Vaccination Progress in Germany'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
