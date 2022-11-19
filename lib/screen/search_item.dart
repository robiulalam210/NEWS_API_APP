import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_api/custom_service/http_custom.dart';
import 'package:news_api/model/news_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  List<Articles> searchList = [];
  FocusNode focusNode = FocusNode();
  List<String> sarchKeyword = [
    "World",
    "Sports",
    "Football",
    "Alamin",
    "Entertainment",
    "fasion"
  ];

  bool isleaoding = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(22),
          child: SingleChildScrollView(
              child: Column(
            children: [
              Container(
                height: 60,
                child: TextField(
                  focusNode: focusNode,
                  controller: searchController,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            searchList = [];
                            searchController.clear();
                            print("akjsgdbjfbvsd");
                            setState(() {});
                          },
                          icon: Icon(Icons.close))),
                  onEditingComplete: () async {
                    print("eeeeeeeeeeeeeeeee");
                    searchList = await Custom_Http()
                        .fechSearchData(query: searchController.text);
                    print("wwwwwwwwww");
                    setState(() {});
                  },
                ),
              ),
              searchList.isEmpty
                  ? SizedBox(
                      height: 100,
                      child: MasonryGridView.count(
                        crossAxisCount: 4,
                        mainAxisSpacing: 20,
                        itemCount: sarchKeyword.length,
                        crossAxisSpacing: 4,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              setState(() {
                                isleaoding = true;
                              });
                              searchController.text = sarchKeyword[index];
                              searchList = await Custom_Http()
                                  .fechSearchData(query: sarchKeyword[index]);
                              setState(() {
                                isleaoding = false;
                              });
                            },
                            child: Text("${sarchKeyword[index]}"),
                          );
                        },
                      ),
                    )
                  : SizedBox(
                      height: 0,
                    ),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: searchList!.length,
                  itemBuilder: (context, index) {
                    return CircleProgressBar(
                      
                      value: 0.5,
                      foregroundColor: Colors.white,
                      child: ListTile(
                        leading:
                            Image.network("${searchList[index].urlToImage}"),
                        title: Text("${searchList[index].title}"),
                        subtitle: Text(
                          "${searchList[index].description}",
                          style: GoogleFonts.lobster(
                              fontSize: 14, color: Colors.black54),
                        ),
                      ),
                    );
                  })
            ],
          )),
        ),
      ),
    );
  }
}
