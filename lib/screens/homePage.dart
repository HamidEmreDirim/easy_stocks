import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:stock_app/screens/addStockPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stock_app/screens/newsPage.dart';
import 'package:stock_app/screens/stocksPage.dart';
import 'package:stock_app/providers/settingsProvider.dart';



class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() =>
      _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
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
  bool isDark = false;
  bool systemDefault = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _switchKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(themeNotifierProvider);
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        
        child: ListView(
          children: [
            UnDraw(
          height: 220,
          
          color: const Color.fromARGB(255, 131, 233, 184),
          illustration: UnDrawIllustration.interior_design,
          placeholder: Text("Illustration is loading..."), //optional, default is the CircularProgressIndicator().
          errorWidget: Icon(Icons.error_outline, color: Colors.red, size: 50), //optional, default is the Text('Could not load illustration!').


        )
            ,
            ListTile(
              
              leading: Text("Dark Mode", style: TextStyle(fontSize: 15),),
              title: Switch(
              key: _switchKey,
              // This bool value toggles the switch.
              value: isDark,
              
              activeColor: Colors.blueGrey,
              onChanged: (bool value) {
                // This is called when the user toggles the switch.
                setState(() {
                  isDark = value;
                });
                if (isDark){
                  notifier.setTheme(ThemeMode.dark);
                }
                else{
                  notifier.setTheme(ThemeMode.light);
                }
                }),
                
            ),
             ListTile(
              leading: Text("Use System Default", style: TextStyle(fontSize: 15),),
              title: Switch(
              // This bool value toggles the switch.
              value: systemDefault,
              activeColor: Colors.blueGrey,
              onChanged: (bool value) {
                // This is called when the user toggles the switch.
                setState(() {
                  systemDefault = value;
                  
                });
                if (systemDefault){
                  notifier.setTheme(ThemeMode.system);
            
             
                }
                }
          
                ),
                

            )
            ,
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Sign Out"),
              onTap: (){
                FirebaseAuth.instance.signOut();
              },
            )

          ],
        ),
      ),
      appBar:  AppBar(
            
            toolbarHeight: 65,
            centerTitle: false,
            leading: (_selectedIndex == 0) ? IconButton(onPressed: (){
              _scaffoldKey.currentState!.openDrawer();
            }, icon: Icon(Icons.menu)) : GestureDetector(child: Icon(Icons.arrow_back),
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
