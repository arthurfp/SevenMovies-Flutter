import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seven_movies/data/fetch_search_results.dart';
import 'package:seven_movies/models/movie_model.dart';
import 'package:seven_movies/models/people_model.dart';
import 'package:seven_movies/models/tv_model.dart';

part 'search_results_event.dart';
part 'search_results_state.dart';

class SearchResultsBloc extends Bloc<SearchResultsEvent, SearchResultsState> {
  SearchResultsBloc() : super(SearchResultsInitial());
  final repo = SearchResultsRepo();
  @override
  Stream<SearchResultsState> mapEventToState(
    SearchResultsEvent event,
  ) async* {
    try {
      if (event is LoadSearchResults) {
        yield SearchResultsLoading();
        final data = await repo.getAllResults(event.query, 1);
        yield SearchResultsLoaded(
          movies: data[0],
          shows: data[1],
          query: event.query,
          moviesCount: repo.movieResultsCount,
          showsCount: repo.showsResultsCount,
          people: data[2],
          peopleCount: repo.peopleResultsCount,
        );
      }
    } catch (e) {
      yield SearchResultsError();
    }
  }
}
