import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/timer_bloc.dart';

class NumPad extends StatelessWidget {
  const NumPad({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: BlocBuilder<TimerBloc, TimerState>(
          buildWhen: (prevState, currState) => prevState.runtimeType != currState.runtimeType,
          builder: (context, state) {
            return Wrap(
              spacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: [
                for (var i = 0; i < 10; i++)
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: RoundedButton(
                      onPressed: (state is TimerInitial)
                          ? () => context.read<TimerBloc>().add(TimerChanged((i + 1) == 10 ? 0 : i + 1))
                          : null,
                      child: Text(
                        ((i + 1) == 10 ? 0 : i + 1).toString(),
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                SizedBox(
                  width: 80,
                  height: 80,
                  child: RoundedButton(
                    onPressed:
                        (state is TimerInitial) ? () => context.read<TimerBloc>().add(const TimerChanged(null)) : null,
                    child: const Icon(Icons.backspace),
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class RoundedButton extends StatelessWidget {
  const RoundedButton({Key? key, required this.child, required this.onPressed}) : super(key: key);

  final Widget child;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
      child: child,
    );
  }
}
