import 'package:flutter/material.dart';
import 'package:news_api/model/news_model.dart';

class DetalisScreen extends StatefulWidget {
  NewsApiModel newsApiModel;

  DetalisScreen(this.newsApiModel) ;
  @override
  State<DetalisScreen> createState() => _DetalisScreenState();
}

class _DetalisScreenState extends State<DetalisScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [

          ],
        ),
      ),
    ));
  }
}
