import 'package:flutter_movie/networking.dart';
import 'package:flutter/material.dart';

const urlMovie = 'https://www.omdbapi.com/?apikey=4f992b25&s=';
const urlMovieDetail = 'https://www.omdbapi.com/?apikey=4f992b25&i=';

class Movie {
  Future<dynamic> getMovieList(String searchTerm) async {
    var url = urlMovie + searchTerm;

    NetworkHelper networkHelper = NetworkHelper(url);

    var movieData = await networkHelper.getData();
    return movieData;
  }

  Future<dynamic> getMovieDetail(String searchTerm) async {
    var url = urlMovieDetail + searchTerm;

    NetworkHelper networkHelper = NetworkHelper(url);

    var movieDetailData = await networkHelper.getData();
    return movieDetailData;
  }
}