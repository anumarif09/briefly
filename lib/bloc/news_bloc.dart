// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../data/repositories/news_repository.dart';
// import 'news_event.dart';
// import 'news_state.dart';

// class NewsBloc extends Bloc<NewsEvent, NewsState> {
//   final NewsRepository repository;

//   NewsBloc({required this.repository}) : super(NewsInitial()) {
//     on<LoadNews>(_onLoadNews);

//     on<LoadGeminiNews>(_onLoadGeminiNews);
//   }

//   Future<void> _onLoadNews(LoadNews event, Emitter<NewsState> emit) async {
//     emit(NewsLoading());

//     try {
//       final news = await repository.getTechNews();

//       emit(NewsLoaded(news));
//     } catch (e) {
//       emit(NewsError(e.toString()));
//     }
//   }

//   Future<void> _onLoadGeminiNews(
//     LoadGeminiNews event,
//     Emitter<NewsState> emit,
//   ) async {
//     emit(NewsLoading());

//     try {
//       final summary = await repository.getGeminiTechNews();

//       emit(GeminiNewsLoaded(summary));
//     } catch (e) {
//       emit(NewsError(e.toString()));
//     }
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repositories/news_repository.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository repository;

  NewsBloc({required this.repository}) : super(NewsInitial()) {
    on<LoadNews>(_onLoadNews);

    on<LoadGeminiNews>(_onLoadGeminiNews);
  }

  Future<void> _onLoadNews(LoadNews event, Emitter<NewsState> emit) async {
    emit(NewsLoading());

    try {
      final news = await repository.getTechNews();

      emit(NewsLoaded(news));
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }

  Future<void> _onLoadGeminiNews(
    LoadGeminiNews event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());

    try {
      final summary = await repository.getGeminiNews(event.category);

      emit(GeminiNewsLoaded(summary));
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }
}
