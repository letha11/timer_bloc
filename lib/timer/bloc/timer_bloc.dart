import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:timer_bloc_tut/utils/ticker.dart';
import 'package:meta/meta.dart';

part 'timer_event.dart';

part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  /// set the default duration to 60 seconds == 1 minute
  // static int? _duration;
  String _temp = '';

  final Ticker _ticker;

  StreamSubscription<int>? _tickerSubscription;

  TimerBloc({required Ticker ticker})
      : _ticker = ticker,
        super(const TimerInitial(0)) {
    on<TimerStarted>(_onTimerStarted);
    on<TimerPaused>(_onTimerPaused);
    on<TimerResumed>(_onTimerResumed);
    on<TimerReset>(_onTimerReset);
    on<TimerChanged>(_onTimerChanged);
    on<_TimerTicked>(_onTimerTicked);
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onTimerChanged(TimerChanged event, Emitter<TimerState> emit) {
    const defaultFormat = '0000';
    int? finalDuration;

    if(event.val == null && _temp.isNotEmpty) {
      _temp = _temp.substring(0, _temp.length - 1);
    }

    if (_temp.length < 4) {
      String resultDuration = '';

      if(event.val != null) {
        _temp += event.val.toString();
      }

      resultDuration = defaultFormat.replaceRange(defaultFormat.length - _temp.length, null, _temp);

      int additionalMinute = 0;
      var splittedDurationRaw = [
        int.parse(resultDuration.substring(0, 2)),
        int.parse(resultDuration.substring(2, resultDuration.length)),
      ];
      additionalMinute = (splittedDurationRaw.last / 60).truncate();
      splittedDurationRaw.last %= 60;
      splittedDurationRaw.first += additionalMinute;

      /// Convert minutes to second and add the second
      finalDuration = (splittedDurationRaw.first * 60 ) + splittedDurationRaw.last;

      emit(TimerInitial(finalDuration ?? 0));
    } else {
      // do nothing
    }
  }

  void _onTimerStarted(TimerStarted event, Emitter<TimerState> emit) {
    if(event.duration > 0) {
      emit(TimerRunInProgress(event.duration));

      /// cancel the subscription stream if there is any
      _tickerSubscription?.cancel();

      /// set the _tickerSubscription to listen to the ticker.tick method
      /// and trigger a new event called _TimerTicked so the ui re-render everytime the timer tick.
      _tickerSubscription = _ticker.tick(ticks: event.duration).listen((duration) => add(_TimerTicked(duration: duration)));

    }
  }

  void _onTimerResumed(TimerResumed event, Emitter<TimerState> emit) {
    if (state is TimerRunPause) {
      /// Resume the subscription
      _tickerSubscription?.resume();
      emit(TimerRunInProgress(state.duration));
    }
  }

  void _onTimerReset(TimerReset event, Emitter<TimerState> emit) {
    _temp = '';

    /// close/cancel the subscription because we don't need it anymore
    _tickerSubscription?.cancel();

    /// emit Initial state with the default duration
    emit(const TimerInitial(0));
  }

  void _onTimerPaused(TimerPaused event, Emitter<TimerState> emit) {
    if (state is TimerRunInProgress) {
      /// Pause the stream tick method
      _tickerSubscription?.pause();

      /// emit/yield TimerRunPause state with the duration of state.duration coming from TimerRunInProgress state
      emit(TimerRunPause(state.duration));
    }
  }

  void _onTimerTicked(_TimerTicked event, Emitter<TimerState> emit) {
    /// emit/yield TimerRunInProgress if the duration is still greater than 0
    /// if it has reached 0, it will emit/yield TimerRunComplete state
    // TODO: every TimerTicked event it will either send TimerRunInProgress state with the duration send in here, or TimerRunComplete.
    if(event.duration > 0) {
      emit(TimerRunInProgress(event.duration));
    } else {
      _temp = '';
      emit(const TimerInitial(0));
    }
    emit(event.duration > 0 ? TimerRunInProgress(event.duration) : const TimerInitial(0));
  }
}
