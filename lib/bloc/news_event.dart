abstract class NewsEvent {}

class LoadNews extends NewsEvent {}

class LoadGeminiNews extends NewsEvent {
  final String category;

  LoadGeminiNews(this.category);
}
