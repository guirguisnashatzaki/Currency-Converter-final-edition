part of 'currency_cubit.dart';

@immutable
abstract class CurrencyState extends Equatable {}

class CurrencyInitial extends CurrencyState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CurrencyLoadedAPI extends CurrencyState{

  final List<SupportedCurrency> currencies;

  CurrencyLoadedAPI(this.currencies);

  @override
  // TODO: implement props
  List<Object?> get props => [currencies];
}

class CurrencyLoadedDB extends CurrencyState{

  final List<SupportedCurrency> currencies;

  CurrencyLoadedDB(this.currencies);

  @override
  // TODO: implement props
  List<Object?> get props => [currencies];
}