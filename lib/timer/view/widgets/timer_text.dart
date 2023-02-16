import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer_bloc_tut/timer/cubit/timer_set_cubit.dart';

import '../../bloc/timer_bloc.dart';

class TimerText extends StatelessWidget {
  const TimerText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const initialString = '0000';

    final duration = context.select<TimerBloc, int>((TimerBloc bloc) => bloc.state.duration);
    final durationRaw = context.select<TimerSetCubit, String>((TimerSetCubit cubit) => cubit.state);

    String resultDuration = initialString.replaceRange(initialString.length - durationRaw.length, null, durationRaw);

    final secondStr = (duration % 60).floor().toString().padLeft(2, '0');
    final minuteStr = ((duration / 60) % 60).floor().toString().padLeft(2, '0');

    // TODO: Learn below code more
    resultDuration = resultDuration.replaceFirstMapped(RegExp(r'.{2}'), (m) {
      return '${m.group(0)}:';
    });

    // print('secondStrRaw = ${duration % 60}');
    // print('minuteStrRaw = ${( (duration / 60) % 60 ).floor()}');
    return Text(
      // '$minuteStr:$secondStr',
      // '',
      resultDuration,
      style: Theme.of(context).textTheme.displayLarge,
    );
  }
}
