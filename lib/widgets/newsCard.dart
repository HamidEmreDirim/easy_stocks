import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_app/data/models.dart/news.dart';

class SingleNewsCard extends StatelessWidget {
  SingleNewsCard({required this.news_data});

  final NewsItem news_data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: [
          Container(
            height: 210,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              image: DecorationImage(
                fit: BoxFit.cover,
                image:  NetworkImage(news_data.image),
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            news_data.title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            children: [
              Text(
                news_data.timeElapsed,
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
              Text(
                " | ",
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
              Text(
                news_data.symbol,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Color.fromRGBO(251, 89, 84, 1),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
