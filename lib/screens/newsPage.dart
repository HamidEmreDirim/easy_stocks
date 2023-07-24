import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:stock_app/data/api_service.dart';
import 'package:stock_app/widgets/miniNewsCard.dart';
import 'package:stock_app/widgets/newsCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/models.dart/news.dart';



class NewsPage
 extends StatefulWidget {
  const NewsPage
  ({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  var symbolList = [];
  bool haveSymbol = false;
  bool haveNews = false;
  List<NewsItem> newsItem = [];

  Future <bool>  getSymbol() async {
    symbolList = [];
     await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get().then(
      (DocumentSnapshot snapshot)  {        
        final userData = snapshot.data() as Map<String, dynamic>;
        for (var item in userData["selected_stocks"]){
          symbolList.add(item);
        }
        }
     );

     setState(() {
       haveNews = true;
     });
     return true;
  }

  

  Future <bool>  getNews() async {
    newsItem = [];
    for (var item in symbolList){
    
    try {
    var data = await ApiService.getStockNew(item);
    for (var item in data["data"]){
      newsItem.add(NewsItem.fromJson(item));     
        }
      } on Error catch (e) {
            print("error asdadsasdad");
            
      }

      }
          
      newsItem.sort((a, b) => a.publishOn.compareTo(b.publishOn));
      newsItem = newsItem.reversed.toList();
      
      setState(() {
          
          haveSymbol = true;
        });

      return true;
  }

  @override
  void initState() {
    getSymbol().then((_) {
    getNews();
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return (haveSymbol && haveNews && newsItem.length > 0) ? LiquidPullToRefresh(
      onRefresh: getNews,
      animSpeedFactor: 6,
      backgroundColor: Colors.black26,
      color: Colors.white12,
      showChildOpacityTransition: false,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 20.0,
              ),
              SingleNewsCard(news_data: newsItem[0],),
              SizedBox(
                height: 30.0,
              ),
              
                ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: newsItem.length - 1,
                itemBuilder: (BuildContext context, int index) {
                  return MiniNewsCard(news_data: newsItem[index + 1],);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 10.0,
                  );
                }
              )
                
            ],
          ),
        ),
      ),
    ) 
    :
    (haveSymbol && haveNews && newsItem.length == 0) ? Center(child: Text("Appearently you dont have not added stocks yet.")) : CircularProgressIndicator();
  }
}




