import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'edit_event_state.dart';

class EditEventCubit extends Cubit<EditEventState> {
  EditEventCubit() : super(EditEventInitial());
}
