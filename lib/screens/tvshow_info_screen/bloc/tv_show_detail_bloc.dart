import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seven_movies/data/fetch_tv_show_info.dart';
import 'package:seven_movies/models/error_model.dart';
import 'package:seven_movies/models/movie_model.dart';
import 'package:seven_movies/models/tv_model.dart';

part 'tv_show_detail_event.dart';
part 'tv_show_detail_state.dart';

class TvShowDetailBloc extends Bloc<TvShowDetailEvent, TvShowDetailState> {
  TvShowDetailBloc() : super(TvShowDetailInitial());
  final FetchTvShowDetail repo = FetchTvShowDetail();
  @override
  Stream<TvShowDetailState> mapEventToState(
    TvShowDetailEvent event,
  ) async* {
    if (event is LoadTvInfo) {
      try {
        yield TvShowDetailLoading();
        final data = await repo.getTvDetails(event.id);
        yield TvShowDetailLoaded(
          backdrops: data[2],
          cast: data[3],
          similar: data[4],
          tmdbData: data[0],
          trailers: data[1],
        );
      } on FetchDataError catch (e) {
        print(e.toString());
        yield TvShowDetailError(error: e);
      } catch (e) {
        print(e.toString());
        yield TvShowDetailError(error: FetchDataError(e.toString()));
      }
    }
  }
}
