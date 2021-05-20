import 'package:flutter/material.dart';
import 'package:news_feed/data/category_info.dart';
import 'package:news_feed/data/search_type.dart';
import 'package:news_feed/view/components/category_chips.dart';
import 'package:news_feed/view/components/search_bar.dart';
import 'package:news_feed/viewmodels/news_list_viewmodel.dart';
import 'package:provider/provider.dart';

class NewsListPage extends StatelessWidget {
  const NewsListPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.refresh),
            tooltip: "更新",
            onPressed: () => onRefresh(context),
          ),
          body: Column(
            children: [
              SearchBar(
                onSearch: (keyword) => getKeywordNews(context, keyword),
              ),
              CategoryChips(
                onCategorySelected: (category) =>
                    getCategoryNews(context, category),
              ),
              //TODO　記事表示
              Expanded(
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
          )),
    );
  }

  //TODO 記事更新処理
  Future<void> onRefresh(BuildContext context) async{
    final viewModel = context.read<NewsListViewModel>();
    await viewModel.getNews(
        searchType: viewModel.searchType,
        keyword: viewModel.keyword,
        category: viewModel.category,
    );
    print("NewsListpage.onRefresh");
  }

  //TODO Keyword取得処理
  Future<void> getKeywordNews(BuildContext context, keyword) async{
    final viewModel = context.read<NewsListViewModel>();
    await viewModel.getNews(
        searchType: SearchType.KEYWORD,
        keyword: keyword,
        category: categories[0]
    );
    print("NewsListpage.getKeywordNews");
  }

  //TODO カテゴリ記事の取得処理
  Future<void> getCategoryNews(BuildContext context, category) async{

    final viewModel = context.read<NewsListViewModel>();
    await viewModel.getNews(
        searchType: SearchType.CATEGORY,
        category: category
    );
    print("NewsListpage.getCategoryNews /category: ${category.nameJp}");
  }
}