import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer_bloc_tut/timer/cubit/timer_set_cubit.dart';

class NumPad extends StatelessWidget {
  const NumPad({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: Wrap(
        spacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        children: [
          for (var i = 0; i < 10; i++)
            SizedBox(
              width: 80,
              height: 80,
              child: FloatingNumberButton(
                onPressed: () => context.read<TimerSetCubit>().changeVal('${(i + 1) == 10 ? 0 : i + 1}'),
                num: (i + 1) == 10 ? 0 : i + 1,
              ),
            ),
        ],
      ),
    );
  }
}

class FloatingNumberButton extends StatelessWidget {
  const FloatingNumberButton({Key? key, required this.num, required this.onPressed}) : super(key: key);

  final int num;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: Text(
        num.toString(),
        style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white),
      ),
    );
  }
}
