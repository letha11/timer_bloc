import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'timer_set_state.dart';

class TimerSetCubit extends Cubit<String> {
  TimerSetCubit() : super('');

  void changeVal(String val) {
    if(state.length < 4) {
      emit(state + val);
    } else {
      print('Maxed');
    }
  }


  @override
  void onChange(Change<String> change) {
    super.onChange(change);
    print(change);
  }
}
