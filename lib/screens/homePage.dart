import 'package:stock_app/screens/addStockPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stock_app/screens/newsPage.dart';
import 'package:stock_app/screens/stocksPage.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() =>
      _HomePageState();
}

class _HomePageState
    extends State<HomePage> {
  int _selectedIndex = 0;

final  _widgetOptions = [
    StocksPage(),
    NewsPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
           
            toolbarHeight: 65,
            centerTitle: false,
            leading: (_selectedIndex == 0) ? PopupMenuButton(
                  child: Icon(
                    Icons.settings,
                    size: 35,
                                      ),
                  itemBuilder: (BuildContext bc) {
    return  [
      PopupMenuItem(
        child: Text("Settings"),
        value: '/hello',
      ),
      PopupMenuItem(
        child: Text("Sign Out"),
        onTap: () {
          FirebaseAuth.instance.signOut();
        },
        
      )
    ];
   
  },
  ): GestureDetector(child: Icon(Icons.arrow_back),
  onTap: () {
    setState(() {
      _selectedIndex = 0;
    });
  },),


        title: (_selectedIndex == 0) ? Center(child: Text("Stocks")): Text("Recent News", textAlign: TextAlign.left,),
            actions: [
              (_selectedIndex == 0) ? Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  
                    borderRadius: BorderRadius.circular(50)),
                width: 45,
                child: IconButton(
                  icon: Icon(Icons.add,
                  size: 35,
                  ),
                  onPressed: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (context) => AddStockPage()));
                  },
                ),
      ): Container(),
            ],),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_exchange),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
