import 'package:flutter_rbna2/bussiness_logic/convert/convert_cubit.dart';
import 'package:flutter_rbna2/bussiness_logic/history/conversion_cubit.dart';
import 'package:flutter_rbna2/models/conversionHistory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import '../helper/test_helper.mocks.dart';

void main(){
  late MockConvertRepository mockConvertRepository;

  late ConvertCubit convertCubit;

  ConversionHistory conversionHistory = ConversionHistory(
    date: "20-2-2024",
    amount: 1,
    convertedAmount: 33.2,
    fromCode: "USD",
    toCode: "EGP",
    fromCurrencyName: "United state dollar",
    toCurrencyName: "Egyptian pound"
  );

  setUp((){
    mockConvertRepository = MockConvertRepository();
    convertCubit = ConvertCubit(mockConvertRepository);
  });

  test(
    'initial test',
      (){
        expect(convertCubit.state, ConvertInitial());
      }
  );
  
  blocTest<ConvertCubit, ConvertState>(
    'convert method test',
    build: () => ConvertCubit(mockConvertRepository),
    act: (bloc) {
      when(mockConvertRepository.convert("USD","EGP",1,"United state dollar","Egyptian pound")).thenAnswer((realInvocation) => Future.value(conversionHistory));
      bloc.convert("USD","EGP",1,"United state dollar","Egyptian pound");
    },

    expect: () => <ConvertState>[
      ConvertLoaded(conversionHistory)
    ]

  );
  
}