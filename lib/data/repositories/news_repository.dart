import '../datasources/news_remote_data_source.dart';
import '../datasources/gemini_remote_data_source.dart';
import '../models/news_item.dart';

class NewsRepository {
  final NewsRemoteDataSource remoteDataSource;

  final GeminiRemoteDataSource geminiRemoteDataSource =
      GeminiRemoteDataSource();

  NewsRepository({required this.remoteDataSource});

  Future<List<NewsItem>> getTechNews() {
    return remoteDataSource.fetchNews();
  }

  Future<String> getGeminiNews(String category) async {
    return await geminiRemoteDataSource.fetchNewsSummary(category);
  }
}
