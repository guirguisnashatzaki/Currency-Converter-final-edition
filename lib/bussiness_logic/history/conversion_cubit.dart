import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_rbna2/models/conversionHistory.dart';
import 'package:flutter_rbna2/repository/historyRepository.dart';
import 'package:meta/meta.dart';

import '../../db_handler/db_handler.dart';

part 'conversion_state.dart';

class ConversionCubit extends Cubit<ConversionState> {

  final HistoryRepository repository;
  List<ConversionHistory> conversions = [];
  ConversionHistory? conversionHistory;

  ConversionCubit(this.repository) : super(ConversionInitial());

  List<ConversionHistory> getAllConversionsDB(){
    repository.getConversionsFromDB().then((value){
      var newList = value;

      emit(ConversionLoaded(newList));
      conversions = newList;
    });

    return conversions;
  }

  ConversionHistory? addConversion(ConversionHistory conversion){
    repository.insertConversion(conversion).then((value){

      var item = value;

      emit(ConversionAdded(item));
      conversionHistory = item;
    });

    return conversionHistory;
  }
}