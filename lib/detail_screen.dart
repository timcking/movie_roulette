import 'package:flutter/material.dart';
import 'package:flutter_movie/movie.dart';
import 'package:flutter_movie/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen({this.imdbId});

  final imdbId;

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

// ignore: must_be_immutable
class _DetailScreenState extends State<DetailScreen> {
  Movie movie = Movie();
  var movieDetail;

  String imdbDetailId = '';
  String movieTitle = '';
  String movieYear = '';
  String moviePoster = '';
  String movieDirector = '';
  String movieRuntime = '';
  String movieRated = '';
  String movieGenre = '';
  String moviePlot = '';
  String movieActors = '';

  @override
  void initState() {
    super.initState();
    imdbDetailId = widget.imdbId;
    buildMovie(imdbDetailId);
  }

  void buildMovie(imdbDetailId) async {
    movieDetail = await movie.getMovieDetail(imdbDetailId);

    setState(() {
      movieTitle = movieDetail['Title'];
      movieYear = movieDetail['Year'];
      moviePoster = movieDetail['Poster'];
      movieDirector = movieDetail['Director'];
      movieRuntime = movieDetail['Runtime'];
      movieRated = movieDetail['Rated'];
      movieGenre = movieDetail['Genre'];
      moviePlot = movieDetail['Plot'];
      movieActors = movieDetail['Actors'];
    });
  }

  // ToDo: Works in emulator but not on device
  // https://stackoverflow.com/questions/63625023/flutter-url-launcher-unhandled-exception-could-not-launch-youtube-url-caused-b/65082750
  _launchURL() async {
    var url = 'https://www.imdb.com/title/$imdbDetailId';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: _launchURL,
            child: Text('$movieTitle',
              style: TextStyle(
                decoration: TextDecoration.underline,
              ),
            )
        ),
      ),
      body: Container(
        padding: new EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.indigo,
        ),
        constraints: BoxConstraints.expand(),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10.0),
            Image(
              image: NetworkImage(moviePoster),
              height: 140,
              width: 160,
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Year',
                  style: kLabelStyle,
                ),
                SizedBox(width: 10.0),
                Text(
                  '$movieYear',
                  style: kDataStyle,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Director',
                  style: kLabelStyle,
                ),
                SizedBox(width: 10.0),
                Text(
                  '$movieDirector',
                  style: kDataStyle,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Runtime',
                  style: kLabelStyle,
                ),
                SizedBox(width: 10.0),
                Text('$movieRuntime', style: kDataStyle),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Rated',
                  style: kLabelStyle,
                ),
                SizedBox(width: 10.0),
                Text('$movieRated', style: kDataStyle),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Plot',
                  style: kLabelStyle,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 320,
                  child: Text(
                    '$moviePlot',
                    style: kPlotStyle,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Cast',
                  style: kLabelStyle,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 320,
                  child: Text(
                    '$movieActors',
                    style: kPlotStyle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
