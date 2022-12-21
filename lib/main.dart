import 'package:flutter/material.dart';
import 'package:flutter_movie/movie.dart';
import 'package:flutter_movie/detail_screen.dart';
import 'package:flutter_movie/constants.dart';
import 'dart:math';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OpenMovie',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title: 'OpenMovie'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Movie movie = Movie();
  var movieDetail;
  var randomMovie;
  var dbPath;
  static const int MAX_MOVIES = 12;
  static const String DATABASE = 'movies.db';
  bool showSpin = false;

  List<Map> listRandom;
  List<String> listRndTitle = [];
  List<String> listRndYear = [];
  List<String> listRndImdbId = [];

  @override
  void initState() {
    super.initState();
    initDatabase();
  }

  void initDatabase() async {
    // TCK, have to manually copy the database file from assets to app dir
    // Construct the path to the app's writable database file:
    var dbDir = await getDatabasesPath();
    dbPath = p.join(dbDir, DATABASE);

    // Delete any existing database:
    // ToDo: check if database exists
    var exists = await databaseExists(dbPath);

    if (!exists) {
      // Create the writable database file from the bundled database file:
      ByteData data = await rootBundle.load("assets/$DATABASE");
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes);
    }
  }

  void buildRandomMovies() async {
    setState(() {
      listRndTitle.clear();
      listRndYear.clear();
      listRndImdbId.clear();
      showSpin = true;
    });

    var db = await openDatabase(dbPath);
    String sql =
        'SELECT title_id FROM movie_list ORDER BY RANDOM() LIMIT $MAX_MOVIES';
    listRandom = await db.rawQuery(sql);

    for (int i = 0; i < MAX_MOVIES; i++) {
      randomMovie = listRandom[i]['title_id'];

      movieDetail = await movie.getMovieDetail(randomMovie);

      if (movieDetail['Response'] == 'False') {
        print('Movie not found');
        continue;
      }

      setState(() {
        listRndTitle.add(movieDetail['Title']);
        listRndYear.add(movieDetail['Year']);
        listRndImdbId.add(movieDetail['imdbID']);
      });
    }

    setState(() {
      showSpin = false;
    });
  }

  void getMovieDetail(String movieId) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DetailScreen(imdbId: movieId);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.indigo,
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                child: ElevatedButton(
                  child: const Text(
                    '  Spin  ',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.deepOrange.shade900,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)), // foreground
                  ),
                  onPressed: () {
                    buildRandomMovies();
                  },
                ),
              ),
              Visibility(
                child: SpinKitThreeBounce(
                  color: Colors.purple,
                  size: 50.0,
                ),
                visible: showSpin,
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: listRndTitle.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      dense: true,
                      onTap: () {
                        getMovieDetail(listRndImdbId[index]);
                      },
                      title: Align(
                          child: Text(
                            listRndTitle[index],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0, // insert your font size here
                            ),
                          ),
                          alignment: Alignment.centerLeft),
                      subtitle: Align(
                        child: Text(
                          listRndYear[index],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0, // insert your font size here
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
