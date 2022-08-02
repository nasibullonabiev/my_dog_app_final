import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_dog_app_final/pages/profile_page.dart';

import 'category_page.dart';
import 'mobile/home_screen.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {
  final int subPage;
  final int crossAxisCount;
  static const id = "";
  const HomePage({Key? key, this.crossAxisCount = 2, this.subPage = 0}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription subscription;
  int _initialPage = 0;
  bool isLoading = false;

  void _onPageChanged(int page) {
    _initialPage = page;
    setState(() {});
  }
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
      if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi || result == ConnectivityResult.ethernet){

        isLoading = false;
        setState((){});
      }else{
        isLoading = true;
        setState((){});
      }
    } on PlatformException catch (e) {
      debugPrint('Couldn\'t check connectivity status: $e');
      return;
    }
  }

  Color _iconColor(int page) => _initialPage == page ? Colors.black : Colors.grey;
  double _iconSize(int page) => _initialPage == page ? 34 : 32;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    subscription = Connectivity().onConnectivityChanged.listen((event) {
      if(event == ConnectivityResult.mobile || event == ConnectivityResult.wifi || event == ConnectivityResult.ethernet) {
        isLoading = false;
        setState((){});
      }else{
        isLoading = true;
        setState((){});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading ? Scaffold(
      resizeToAvoidBottomInset: false,
      body: Row(
        children: [
          Visibility(
            visible: widget.crossAxisCount > 5,
            child: Drawer(
              backgroundColor: Colors.white,
              width: 250,
              child: Column(
                children: [
                  DrawerHeader(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(125),
                      child: const Image(
                        image: AssetImage("assets/images/logo.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  ListTile(
                    onTap: () => _onPageChanged(0),
                    leading: Icon(Icons.home_filled, size: _iconSize(0), color: _iconColor(0)),
                    title: Text("Home"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    onTap: () => _onPageChanged(1),
                    leading: Icon(Icons.search, size: _iconSize(1), color: _iconColor(1)),
                    title: Text("Search"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    onTap: () => _onPageChanged(2),
                    leading: Icon(CupertinoIcons.chat_bubble_text_fill, size: _iconSize(2), color: _iconColor(2)),
                    title: Text("Category"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    onTap: () => _onPageChanged(3),
                    leading: Icon(CupertinoIcons.profile_circled, size: _iconSize(3), color: _iconColor(3)),
                    title: Text("Profile"),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: widget.crossAxisCount > 3 && widget.crossAxisCount < 6,
            child: NavigationRail(
                minWidth: 100,
                onDestinationSelected: _onPageChanged,
                destinations: [
                  NavigationRailDestination(
                    label: const Text("Home"),
                    icon: Icon(Icons.home_filled, size: _iconSize(0), color: _iconColor(0)),
                  ),
                  NavigationRailDestination(
                    label: const Text("Search"),
                    icon: Icon(Icons.search, size: _iconSize(1), color: _iconColor(1)),
                  ),
                  NavigationRailDestination(
                    label: const Text("Category"),
                    icon: Icon(CupertinoIcons.chat_bubble_text_fill, size: _iconSize(2), color: _iconColor(2)),
                  ),
                  NavigationRailDestination(
                    label: const Text("Profile"),
                    icon: Icon(CupertinoIcons.profile_circled, size: _iconSize(3), color: _iconColor(3)),
                  ),
                ],
                selectedIndex: _initialPage
            ),
          ),
          SizedBox(
            width: widget.crossAxisCount > 5 ? MediaQuery.of(context).size.width - 250 : (widget.crossAxisCount > 3 ? MediaQuery.of(context).size.width - 100 : MediaQuery.of(context).size.width),
            child: IndexedStack(
              index: _initialPage,
              children: [
                HomeScreen(crossAxisCount: widget.crossAxisCount, subPage: widget.subPage),
                SearchPage(crossAxisCount: widget.crossAxisCount,),
                CategoryPage(crossAxisCount: widget.crossAxisCount,),
                ProfilePage(crossAxisCount: widget.crossAxisCount,),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: widget.crossAxisCount <= 3 ? Container(
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 60),
        padding: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(35),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 20,
                  spreadRadius: 0.5,
                  blurStyle: BlurStyle.normal
              )
            ]
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => _onPageChanged(0),
              icon: Icon(Icons.home_filled, size: _iconSize(0), color: _iconColor(0)),
            ),
            IconButton(
              onPressed: () => _onPageChanged(1),
              icon: Icon(Icons.search, size: _iconSize(1), color: _iconColor(1)),
            ),

            IconButton(
              onPressed: () => _onPageChanged(2),
              icon: Icon(CupertinoIcons.chat_bubble_text_fill, size: _iconSize(2), color: _iconColor(2)),
            ),

            IconButton(
              onPressed: () => _onPageChanged(3),
              icon: Icon(CupertinoIcons.profile_circled, size: _iconSize(3), color: _iconColor(3)),
            ),
          ],
        ),
      ) : null,
    ): Scaffold(
      body: Center(child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("No internet connection!", style: TextStyle(fontSize: 18),),
          SizedBox(width: 20,),
          Icon(Icons.wifi_off_sharp),
        ],
      ),),
    );
  }
}