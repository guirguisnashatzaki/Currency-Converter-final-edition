part of 'conversion_cubit.dart';

@immutable
abstract class ConversionState extends Equatable {}

class ConversionInitial extends ConversionState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ConversionLoaded extends ConversionState{

  final List<ConversionHistory> conversions;

  ConversionLoaded(this.conversions);

  @override
  // TODO: implement props
  List<Object?> get props => [conversions];
}

class ConversionAdded extends ConversionState{

  final ConversionHistory conversionHistory;

  ConversionAdded(this.conversionHistory);

  @override
  // TODO: implement props
  List<Object?> get props => [conversionHistory];
}