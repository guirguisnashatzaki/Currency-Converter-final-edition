import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_rbna2/bussiness_logic/currency/currency_cubit.dart';
import 'package:flutter_rbna2/models/supportedCurrencies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helper/test_helper.mocks.dart';

void main(){
  late MockCurrencyRepository mockCurrencyRepository;

  late CurrencyCubit currencyCubit;

  SupportedCurrency supportedCurrency = SupportedCurrency();

  setUp((){
    mockCurrencyRepository = MockCurrencyRepository();
    currencyCubit = CurrencyCubit(mockCurrencyRepository);
  });

  test(
      'initial test',
          (){
        expect(currencyCubit.state, CurrencyInitial());
      }
  );

  blocTest<CurrencyCubit, CurrencyState>(
      'convert DB method test',
      build: () => CurrencyCubit(mockCurrencyRepository),
      act: (bloc) {
        when(mockCurrencyRepository.getAllSupportedCurrenciesFromDB()).thenAnswer((realInvocation) => Future.value([supportedCurrency]));
        bloc.getAllCurrenciesDB();
      },

      expect: () => <CurrencyState>[
        CurrencyLoadedDB([supportedCurrency])
      ]
  );

  blocTest<CurrencyCubit, CurrencyState>(
      'convert API method test',
      build: () => CurrencyCubit(mockCurrencyRepository),
      act: (bloc) {
        when(mockCurrencyRepository.getAllSupportedCurrencies()).thenAnswer((realInvocation) => Future.value([supportedCurrency]));
        bloc.getAllCurrenciesAPI();
      },

      expect: () => <CurrencyState>[
        CurrencyLoadedAPI([supportedCurrency])
      ]
  );

  blocTest<CurrencyCubit, CurrencyState>(
      'convert DB method test empty data',
      build: () => CurrencyCubit(mockCurrencyRepository),
      act: (bloc) {
        when(mockCurrencyRepository.getAllSupportedCurrenciesFromDB()).thenAnswer((realInvocation) => Future.value([]));
        when(mockCurrencyRepository.getAllSupportedCurrencies()).thenAnswer((realInvocation) => Future.value([supportedCurrency]));
        bloc.getAllCurrenciesDB();
      },

      expect: () => <CurrencyState>[
        CurrencyLoadedAPI([supportedCurrency])
      ]
  );
}