part of 'convert_cubit.dart';

@immutable
abstract class ConvertState extends Equatable {}

class ConvertInitial extends ConvertState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ConvertLoaded extends ConvertState{

  final ConversionHistory conversion;

  ConvertLoaded(this.conversion);


  @override
  // TODO: implement props
  List<Object?> get props => [conversion];
}
