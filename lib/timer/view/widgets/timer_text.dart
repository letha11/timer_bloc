import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/timer_bloc.dart';

class TimerText extends StatelessWidget {
  const TimerText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final duration = context.select<TimerBloc, int>((TimerBloc bloc) => bloc.state.duration);
    final secondStr = (duration % 60).floor().toString().padLeft(2, '0');
    final minuteStr = ((duration / 60) % 60).floor().toString().padLeft(2, '0');

    return Text(
      '$minuteStr:$secondStr',
      style: Theme.of(context).textTheme.displayLarge,
    );
  }
}
