import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'sale_state.dart';

class SaleCubit extends Cubit<SaleState> {
  SaleCubit() : super(SaleInitial());
}
