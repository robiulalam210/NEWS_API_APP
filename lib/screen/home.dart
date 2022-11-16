import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:news_api/const.dart';
import 'package:news_api/custom_service/http_custom.dart';
import 'package:news_api/model/news_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageNo = 1;
  String sortBy = "popularity";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,title: Text("News App"),),
      body: Container(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Card(
                elevation: 10,
                child: Container(
                    height: 40,
                    // color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(onPressed: () {}, child: Text("Next")),
                        Flexible(
                            child: ListView.builder(
                                itemCount: 10,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => Card(
                                    elevation: 6,
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 12),
                                      child: Center(
                                          child: Text(
                                        "${index + 1}",
                                        textAlign: TextAlign.center,
                                      )),
                                    )))),
                        ElevatedButton(onPressed: () {}, child: Text("Prives")),
                      ],
                    )),
              ),

              SizedBox(height: MediaQuery.of(context).size.height*0.01,),
              Container(
                child:  TextField(
                  style: TextStyle(color: Colors.white),
                  cursorRadius: Radius.circular(30),
                  cursorColor: Color(0xff8A8A8E),
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.all(5),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Colors.blue)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Color(0xff8A8A8E))),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      prefixIcon: Icon(Icons.search_rounded),
                      prefixIconColor: Color(0xff8A8A8E).withOpacity(0.7),
                      suffixIconColor: Color(0xff8A8A8E).withOpacity(0.7),
                      hintText: "Search.......",
                      hintStyle: TextStyle(color: Color(0xff8A8A8E))),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.01,),

              FutureBuilder<List<Articles>>(
                  future: Custom_Http().dataAll(pageNo: pageNo, sortBy: sortBy),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Text("Data HasError!");
                    } else if (snapshot.data == null) {
                      return Text("No data");
                    }
                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.lightGreen,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: ListTile(
                                title: Text("${snapshot.data![index].title}",style:TextStyle(fontSize: 20),maxLines: 2,softWrap: true,),
                                subtitle: Text(
                                    "${snapshot.data![index].description}",style: TextStyle(fontSize: 16),maxLines: 3,),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                      "${snapshot.data![index].urlToImage}",fit: BoxFit.cover,),
                                ),
                              ),
                            ));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
