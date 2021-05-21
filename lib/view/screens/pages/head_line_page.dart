import 'package:flutter/material.dart';
import 'package:news_feed/data/category_info.dart';
import 'package:news_feed/data/search_type.dart';
import 'package:news_feed/view/components/page_transformer.dart';
import 'package:news_feed/viewmodels/head_line_viewmodel.dart';
import 'package:provider/provider.dart';

class HeadLinePage extends StatelessWidget {
  const HeadLinePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<HeadLineViewModel>();
    if (!viewModel.isLoading && viewModel.articles.isEmpty) {
      Future(() => viewModel.getHeadLines(
          searchType: SearchType.HEAD_LINE));
    }
    return SafeArea(
      child: Scaffold(
        body: Consumer<HeadLineViewModel>(
          builder: (context, model, child){
            return PageTransformer(
              pageViewBuilder: (context, pageVisibilityResolver){
                return PageView.builder(
                  controller: PageController(),
                  itemCount: model.articles.length,
                  itemBuilder: (context, index){
                    final article = model.articles[index];
                    final pageVisibility = pageVisibilityResolver.resolvePageVisibility(index);
                    final visibleFraction = pageVisibility.visibleFraction;
                    return Opacity(
                      opacity: visibleFraction,
                      child: Container(
                        color: Colors.blue,
                        child: Center(
                          child: Column(
                            children: [
                              Text(article.title),
                              Text(article.description),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          onPressed: () => onRefresh(context),
        ),
      ),
    );
  }

  //TODO 更新処理
  onRefresh(BuildContext context)  async{
    print("HeadLinePage.onRefresh");
    final viewModel = context.read<HeadLineViewModel>();
    await viewModel.getHeadLines(searchType: SearchType.HEAD_LINE);
  }
}
