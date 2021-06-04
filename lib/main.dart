import 'package:band_names/app/features/pages/home.dart';
import 'package:band_names/app/features/pages/status.dart';
import 'package:band_names/services/socket_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> SocketServices() )
      ],
          child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        initialRoute: 'home',
        routes: {
          'home' : (_)=> HomePage(),
          'status':(_)=> StatusPage(),

        },
      ),
    );
  }
}


