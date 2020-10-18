import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class Home extends StatefulWidget {
  final String title;

  const Home({Key key, this.title}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String baseUrl = "https://rickandmortyapi.com/api/character?page=";

  var characters;

  Future<void> _getCharacters() async {
    String random = Random.secure().nextInt(34).toString();
    var response = await http.get(baseUrl + random);
    print(baseUrl + random);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        characters = data["results"];
      });
      print(data["results"]);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _getCharacters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: characters != null
          ? RefreshIndicator(
              onRefresh: _getCharacters,
              child: ListView.builder(
                  itemCount: characters.length,
                  itemBuilder: (context, index) => Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 200,
                                  width: 150,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                    child: Image(
                                      image: NetworkImage(
                                          characters[index]["image"]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        characters[index]["name"],
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Row(
                                        children: [
                                          characters[index]["status"] == "Alive"
                                              ? Container(
                                                  width: 10,
                                                  height: 10,
                                                  decoration: BoxDecoration(
                                                      color: Colors.greenAccent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                )
                                              : characters[index]["status"] ==
                                                      "Dead"
                                                  ? Container(
                                                      width: 10,
                                                      height: 10,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Colors.redAccent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                    )
                                                  : Container(
                                                      width: 10,
                                                      height: 10,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.greenAccent,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                    ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            characters[index]["status"],
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            characters[index]["species"],
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 1.2,
                                            ),
                                          )
                                        ],
                                      ),
                                      Text(
                                        "Last known location:",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                      Text(
                                        characters[index]["location"]["name"],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                      Text(
                                        "Origin",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                      Text(
                                        characters[index]["origin"]["name"],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1.2,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
            )
          : RefreshIndicator(
              child: SingleChildScrollView(
                child: Center(
                  child: Text("Refresh"),
                ),
              ),
              onRefresh: _getCharacters,
            ),
    );
  }
}
