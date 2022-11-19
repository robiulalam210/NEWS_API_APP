import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:news_api/const.dart';
import 'package:news_api/custom_service/http_custom.dart';
import 'package:news_api/model/news_model.dart';
import 'package:news_api/screen/search_item.dart';
import 'package:news_api/screen/tabs.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageNo = 1;
  List<String> list = <String>["relevancy", "popularity", "publishedAt"];
  String sortBy = "relevancy";
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'News app',
          style: GoogleFonts.lobster(
              textStyle: TextStyle(
                  color: Colors.black, fontSize: 20, letterSpacing: 0.6)),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  duration: Duration(milliseconds: 30),
                    type: PageTransitionType.rightToLeft,
                    child: SearchPage(),
                    inheritTheme: true,
                    ctx: context),
              );
            },
            icon: const Icon(
              Icons.search,
            ),
          )
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
                children: [
                  TabsWidget(
                    text: 'All news',
                    color: Colors.white,
                    fontSize: 20,
                    function: () {},
                    // color: newsType == NewsType.allNews
                    //     ? Theme.of(context).cardColor
                    //     : Colors.transparent,
                    // function: () {
                    //   if (newsType == NewsType.allNews) {
                    //     return;
                    //   }
                    //   setState(() {
                    //     newsType = NewsType.allNews;
                    //   });
                    // },
                    // fontSize: newsType == NewsType.allNews ? 22 : 14,
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  TabsWidget(
                    text: 'Top trending',
                    color: Colors.white,
                    fontSize: 20,
                    function: () {},
                    // color: newsType == NewsType.topTrending
                    //     ? Theme.of(context).cardColor
                    //     : Colors.transparent,
                    // function: () {
                    //   if (newsType == NewsType.topTrending) {
                    //     return;
                    //   }
                    //   setState(() {
                    //     newsType = NewsType.topTrending;
                    //   });
                    // },
                    // fontSize: newsType == NewsType.topTrending ? 22 : 14,
                  ),
                ],
              ),
              Card(
                child: Container(
                    height: 40,
                    // color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              if (currentIndex < 1) {
                              } else {
                                setState(() {
                                  currentIndex = currentIndex - 1;
                                });
                              }
                            },
                            child: Text("Prev")),
                        Flexible(
                            child: ListView.builder(
                                itemCount: 10,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => Card(
                                    elevation: 1,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          currentIndex = index + 1;
                                        });
                                      },
                                      child: Container(
                                        color: index + 1 == currentIndex
                                            ? Colors.blue
                                            : Colors.transparent,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Center(
                                            child: Text(
                                          "${index + 1}",
                                          textAlign: TextAlign.center,
                                        )),
                                      ),
                                    )))),
                        ElevatedButton(
                            onPressed: () {
                              if (currentIndex > 1) {
                                setState(() {
                                  currentIndex = currentIndex + 1;
                                });
                              }
                            },
                            child: Text("Next")),
                      ],
                    )),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    alignment: Alignment.center,
                    height: 45,
                    width: 150,
                    padding: EdgeInsets.all(4),
                    margin: EdgeInsets.only(right: 10),
                    child: DropdownButton<String>(
                      value: sortBy,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 8,
                      style: const TextStyle(color: Colors.black),
                      underline: Container(
                        height: 2,
                        color: Colors.black,
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          sortBy = value!;
                        });
                      },
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
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
                        itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NewsDetailsScreen(snapshot.data![index])));
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 5),
                                margin: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  // color: Colors.lightGreen,
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: ListTile(
                                  title: Text(
                                    "${snapshot.data![index].title}",
                                    style: TextStyle(fontSize: 16),
                                    maxLines: 2,
                                    softWrap: true,
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.punch_clock),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text("less thean a minute"),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.link),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                              "${snapshot.data![index].publishedAt}"),
                                        ],
                                      ),
                                    ],
                                  ),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.network(
                                      "${snapshot.data![index].urlToImage}",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
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
