import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news_api/const.dart';
import 'package:news_api/model/news_model.dart';
import 'package:http/http.dart' as http;

class Custom_Http {
  Future<List<Articles>> dataAll(
      {required int pageNo, required String sortBy}) async {
    List<Articles> alldata = [];
    Articles articles;
    String uriBase =
        "${baseUrl}q=apple&page=$pageNo&pageSize=10&sortBy=$sortBy&apiKey=${token}";
    var recponce = await http.get(Uri.parse(uriBase));
    var data = jsonDecode(recponce.body);

    for (var i in data["articles"]) {
      articles = Articles.fromJson(i);
      alldata.add(articles);
    }

    return alldata;
    print("rrrrrrrrrrrrrrrrrr${recponce.body}");
  }
}
