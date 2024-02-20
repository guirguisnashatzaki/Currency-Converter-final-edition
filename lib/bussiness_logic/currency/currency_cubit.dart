import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../models/supportedCurrencies.dart';
import '../../repository/currencyRepository.dart';
part 'currency_state.dart';

class CurrencyCubit extends Cubit<CurrencyState> {
  final CurrencyRepository repository;
  List<SupportedCurrency> currencies = [];
  SupportedCurrency? currency;

  CurrencyCubit(this.repository) : super(CurrencyInitial());

  List<SupportedCurrency> getAllCurrenciesAPI(){
    repository.getAllSupportedCurrencies().then((value) async {
          var newList = value;

          emit(CurrencyLoadedAPI(newList));
          currencies = newList;
    });

    return currencies;
  }

  List<SupportedCurrency> getAllCurrenciesDB(){
    repository.getAllSupportedCurrenciesFromDB().then((value){
      if(value.isEmpty){
        getAllCurrenciesAPI();
      }else{
        var newList = value;

        emit(CurrencyLoadedDB(newList));
        currencies = newList;
      }
    });

    return currencies;
  }

  Future<void> addAll(List<SupportedCurrency> value)async {
    for (var element in value) {
      addCurrency(element);
    }
  }

  SupportedCurrency addCurrency(SupportedCurrency currency){
    repository.insertCurrency(currency).then((value){
      var item = value;
      currency = item;
    });

    return currency;
  }
}