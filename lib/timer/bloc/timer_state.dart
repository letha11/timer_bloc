part of 'timer_bloc.dart';

@immutable
abstract class TimerState extends Equatable {
  const TimerState(this.duration);
  final int duration;

  @override
  List<Object?> get props => [duration];
}

class TimerInitial extends TimerState {
  const TimerInitial(super.duration);

  @override
  toString() => 'TimerInitial { duration: $duration } ';
}
class TimerRunInProgress extends TimerState {
  const TimerRunInProgress(super.duration);

  @override
  toString() => 'TimerRunInProgress { duration: $duration } ';
}
class TimerRunPause extends TimerState {
  const TimerRunPause(super.duration);

  @override
  toString() => 'TimerRunPause { duration: $duration } ';
}

class TimerRunComplete extends TimerState {
  const TimerRunComplete() : super(0);
}
