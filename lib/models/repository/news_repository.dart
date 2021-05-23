import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:news_feed/data/category_info.dart';
import 'package:news_feed/data/search_type.dart';
import 'package:news_feed/models/model/news_model.dart';
import 'package:news_feed/models/network/api_service.dart';
import 'package:news_feed/main.dart';
import 'package:news_feed/util/extensions.dart';

class NewsRepository {

  final ApiService _apiService = ApiService.create();

  Future<List<Article>> getNews(
      {@required SearchType searchType,
      String keyword,
      Category category}) async {

    List<Article> result = List<Article>();
    Response response;

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

      if (response.isSuccessful){
        final responseBody = response.body;
        print("responseBody: $responseBody");
        result = await insertAndReadFromDB(responseBody);
        print("result(article): $result");

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

  Future<List<Article>> insertAndReadFromDB(responseBody) async{
    final dao = myDatabase.newsDao;
    final articles = News.fromJson(responseBody).articles;

    // Webから取得した記事（Dartのモデルクラス：Article）を
    // DBのテーブルクラス（Articles）に変換してDBへ登録 ＆ DBから取得
    final articleRecords = await dao.insertAndReadNewsFromDB(
        articles.toArticleRecords(articles));

    // DBから取得したデータをデータモデルクラスに再変化して返す
    return articleRecords.toArticles(articleRecords);
  }
}
