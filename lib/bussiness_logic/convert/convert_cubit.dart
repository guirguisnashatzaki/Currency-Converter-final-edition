import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/conversionHistory.dart';
import '../../repository/convertRepository.dart';

part 'convert_state.dart';

class ConvertCubit extends Cubit<ConvertState> {
  final ConvertRepository repository;
  ConversionHistory? conversionHistory;

  ConvertCubit(this.repository) : super(ConvertInitial());

  convert(String fromCode,String toCode,double amount,String fromName,String toName){
    repository.convert(fromCode, toCode, amount, fromName, toName).then((value){
      var item = value;

      emit(ConvertLoaded(item!));
      conversionHistory = item;
    });
    return conversionHistory;
  }
}