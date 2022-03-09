import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:seven_movies/data/fetch_home_screen_data.dart';
import 'package:seven_movies/models/error_model.dart';
import 'package:seven_movies/models/movie_model.dart';
import 'package:seven_movies/models/tv_model.dart';

part 'fetch_home_event.dart';
part 'fetch_home_state.dart';

class FetchHomeBloc extends Bloc<FetchHomeEvent, FetchHomeState> {
  FetchHomeBloc() : super(FetchHomeInitial());
  final FetchHomeRepo repo = FetchHomeRepo();
  @override
  Stream<FetchHomeState> mapEventToState(
    FetchHomeEvent event,
  ) async* {
    if (event is FetchHomeData) {
      yield FetchHomeLoading();
      try {
        final data = await repo.getHomePageMovies();
        yield FetchHomeLoaded(
          topShows: data[4],
          tranding: data[0],
          tvShows: data[5],
          upcoming: data[3],
          nowPlaying: data[1],
          topRated: data[2],
        );
      } on FetchDataError catch (e) {
        yield FetchHomeError(error: e);
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
