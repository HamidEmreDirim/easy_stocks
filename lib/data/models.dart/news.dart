import 'package:intl/intl.dart';

class NewsItem {
  String id;
  String image;
  String title;
  String publishOn;
  String timeElapsed;
  String symbol;
  // Add other attributes if needed

   

  NewsItem({required this.id,required this.image,required this.publishOn, required this.title, required this.timeElapsed, required this.symbol});

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'],
      image: json['attributes']["gettyImageUrl"],
      title: json["attributes"]["title"],     
      publishOn: json['attributes']['publishOn'],
      timeElapsed: timePassedSincePublished(json['attributes']['publishOn']),
      symbol: json["symbol"]
      // Initialize other attributes here if needed
    );
  }
}


String timePassedSincePublished(String publishDate) {
    DateTime now = DateTime.now();
    DateTime publishTime = DateTime.parse(publishDate);
    Duration difference = now.difference(publishTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      // Format the "publishOn" time to display a custom date format if it's more than a day ago
      return DateFormat('yyyy-MM-dd').format(publishTime);
    }
  }