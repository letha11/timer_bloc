import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:timer_bloc_tut/utils/ticker.dart';
import 'package:meta/meta.dart';

part 'timer_event.dart';

part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  /// set the default duration to 60 seconds == 1 minute
  static const int _duration = 60;

  final Ticker _ticker;

  StreamSubscription<int>? _tickerSubscription;

  TimerBloc({required Ticker ticker})
      : _ticker = ticker,
        super(const TimerInitial(_duration)) {
    on<TimerStarted>(_onTimerStarted);
    on<TimerPaused>(_onTimerPaused);
    on<TimerResumed>(_onTimerResumed);
    on<TimerReset>(_onTimerReset);
    on<_TimerTicked>(_onTimerTicked);
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onTimerStarted(TimerStarted event, Emitter<TimerState> emit) {
    /// emit TimerRunInProgress state with the duration that event(TimerStarted) had
    emit(TimerRunInProgress(event.duration));

    /// cancel the subscription stream if there is any
    _tickerSubscription?.cancel();

    /// set the _tickerSubscription to listen to the ticker.tick method
    /// and trigger a new event called _TimerTicked so the ui re-render everytime the timer tick.
    _tickerSubscription =
        _ticker.tick(ticks: event.duration).listen((duration) => add(_TimerTicked(duration: duration)));
  }

  void _onTimerResumed (TimerResumed event, Emitter<TimerState> emit) {
    if(state is TimerRunPause) {
      /// Resume the subscription
      _tickerSubscription?.resume();
      emit(TimerRunInProgress(state.duration));
    }
  }

  void _onTimerReset (TimerReset event, Emitter<TimerState> emit) {
    /// close/cancel the subscription because we don't need it anymore
    _tickerSubscription?.cancel();
    /// emit Initial state with the default duration
    emit(const TimerInitial(_duration));
  }

  void _onTimerPaused (TimerPaused event, Emitter<TimerState> emit) {

    if(state is TimerRunInProgress) {
      /// Pause the stream tick method
      _tickerSubscription?.pause();
      /// emit/yield TimerRunPause state with the duration of state.duration coming from TimerRunInProgress state
      emit(TimerRunPause(state.duration));
    }
  }

  void _onTimerTicked(_TimerTicked event, Emitter<TimerState> emit) {
    /// emit/yield TimerRunInProgress if the duration is still greater than 0
    /// if it has reached 0, it will emit/yield TimerRunComplete state
    emit(event.duration > 0 ? TimerRunInProgress(event.duration) : const TimerRunComplete());
  }
}
