import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';
bool isConnected = true;
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  String? connectionStatus;
  late StreamSubscription subscription;



  @override
  void initState() {
    super.initState();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult connectivityResult) {
      print(connectivityResult);
    });
    checkStatus();
  }


  void checkStatus()async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult != ConnectivityResult.mobile  && connectivityResult != ConnectivityResult.wifi){
      setState(() {
        isConnected = false;
        connectionStatus = "Please Turn on Mobile Network or Wi-Fi";
      });

    }else{
      setState(() {
        isConnected = true;
        connectionStatus = "Connected Network!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isConnected ? LayoutBuilder(
        builder: (context, boxConstraints) {
          int crossAxisCount = boxConstraints.maxWidth ~/ 250;
          if(boxConstraints.maxWidth < 580) {
            // phone
            return const HomePage(crossAxisCount: 2);
          } if(boxConstraints.maxWidth < 1025) {
            // tablet
            return HomePage(crossAxisCount: crossAxisCount);
          } else {
            // desktop
            return HomePage(crossAxisCount: crossAxisCount);
          }
        }
    ) : const Center(
      child: Text("Please turn on Wi-Fi or mobile data"),
    );
  }
}
