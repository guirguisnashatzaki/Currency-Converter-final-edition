import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_rbna2/bussiness_logic/history/conversion_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helper/test_helper.mocks.dart';

void main(){
  late MockHistoryRepository mockHistoryRepository;

  late ConversionCubit conversionCubit;

  setUp((){
    mockHistoryRepository = MockHistoryRepository();
    conversionCubit = ConversionCubit(mockHistoryRepository);
  });

  test(
      'initial test',
          (){
        expect(conversionCubit.state, ConversionInitial());
      }
  );

  blocTest<ConversionCubit, ConversionState>(
      'conversion DB method test',
      build: () => ConversionCubit(mockHistoryRepository),
      act: (bloc) {
        when(mockHistoryRepository.getConversionsFromDB()).thenAnswer((realInvocation) => Future.value([]));
        bloc.getAllConversionsDB();
      },

      expect: () => <ConversionState>[
        ConversionLoaded([])
      ]
  );

}