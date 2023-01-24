import 'package:flutter/material.dart';
import 'package:flashing_tool/native.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ION Flashing tool',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'ION Flashing tool'),
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
  @override
  void initState(){
    api.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Flutter Battery Window"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          FutureBuilder(
            future: api.getBatteryStatus(),
            builder: (context,data){
              return Text(
                'System has battery present: ${data.data}',
                style: TextStyle(
                  color: (data.data ?? false) ? Colors.green : Colors.red
                ),
              );
            }),
            StreamBuilder(
              stream: api.batteryEventStream(),
              builder: (context,data){
                if (data.hasData){
                  return Column(
                    children: [
                      Text("Charge rate in milliwatts: ${data.data!.chargeRatesInMilliwatts.toString()}"),
                      Text("Design capacity in milliwatts: ${data.data!.designCapacityInMilliwattHours.toString()}"),
                      Text("Full charge in milliwatt hours: ${data.data!.fullChargeCapacityInMilliwattHours.toString()}"),
                      Text("Remaining capacity in milliwatts: ${data.data!.remainingCapacityInMilliwattHours}"),
                      Text("Battery status is ${data.data!.status}")
                    ],
                  );
                }
                return Column(
                  children: const [
                    Text("Waiting for a battery event."),
                    Text("If you have a desktop computer with no battery, this event will never come..."),
                    CircularProgressIndicator(),
                  ],
                );
              })
        ]),
      ),
    );
  }
}

