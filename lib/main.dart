import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:session_12/my_hook.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      builder: (context, child) =>
          ResponsiveWrapper.builder(child, breakpoints: [
        const ResponsiveBreakpoint.resize(500, name: MOBILE),
        const ResponsiveBreakpoint.resize(850, name: TABLET),
        const ResponsiveBreakpoint.resize(1000, name: DESKTOP)
      ]),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Platform Channels',
      ),
    );
  }
}

class Example extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useContext();
    final animation = useFadeTransition(useAnimationController());
    return Scaffold();
  }

  abcd() {
    MediaQuery.of(useContext()).size;
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel('dorset.sample/battery');

  String _batteryLevel = 'Unknown';
  String _acStatus = 'Unknown';
  Future<void> getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('percentage');
      batteryLevel = 'Your battery level is $result %';
    } on PlatformException catch (e) {
      batteryLevel = 'Platform implementation not found! ${e.message}';
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  Future<void> getACStatus() async {
    String? status;
    try {
      final String result = await platform.invokeMethod('charge_status');
    } on PlatformException catch (e) {
      status = 'Platform implementation not found! ${e.message}';
    }

    setState(() {
      _acStatus = status!;
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Widht:  ${MediaQuery.of(context).size.width}'),
            Text('Height: ${MediaQuery.of(context).size.height}'),
            Text(_batteryLevel),
            ElevatedButton(
                onPressed: getBatteryLevel, child: Text("Get Battery Level")),
            Text(_acStatus),
            ElevatedButton(onPressed: getACStatus, child: Text("Get AC status"))
          ],
        ),
      ),
    );
  }
}
