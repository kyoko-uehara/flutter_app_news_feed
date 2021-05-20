import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:news_feed/data/category_info.dart';
import 'package:news_feed/data/search_type.dart';
import 'package:news_feed/models/model/news_model.dart';
import 'package:news_feed/models/network/api_service.dart';

class NewsRepository {

  final ApiService _apiService = ApiService.create();

  Future<List<Article>> getNews(
      {@required SearchType searchType,
      String keyword,
      Category category}) async {

    List<Article> result = List<Article>();
    Response response;

    print("[NewsRepository] SearchType: $searchType / keyword: $keyword / category: ${category.nameEn}");

    try {
      switch (searchType) {
        case SearchType.HEAD_LINE:
          response = await _apiService.getHeadLines();
          break;
        case SearchType.KEYWORD:
          response = await _apiService.getKeywordNews(keyword: keyword);
          break;
        case SearchType.CATEGORY:
          response = await _apiService.getCategoryNews(category: category.nameEn);
          break;
      }

      //if (response.isSuccessful){
      if (response.statusCode >= 200 && response.statusCode < 300){
        final responseBody = response.body;
        print("responseBody: $responseBody");
        result = News.fromJson(responseBody).article;

      }
      else{
        final errorCode = response.statusCode;
        final error = response.error;
        print("response is not successful: $errorCode / $error");
      }
    }on Exception catch (e){
      print("error: $e");
    }


    return result;
  }

  void dispose(){
    _apiService.dispose();
  }
}
