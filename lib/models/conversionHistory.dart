class ConversionHistory {
  String? fromCode;
  String? toCode;
  String? fromCurrencyName;
  String? toCurrencyName;
  double? amount;
  double? convertedAmount;
  String? date;

  ConversionHistory({this.fromCode, this.toCode, this.amount, this.convertedAmount, this.date, this.fromCurrencyName, this.toCurrencyName});

  ConversionHistory.fromJson(Map<String, dynamic> json) {
    fromCode = json['from_code'];
    toCode = json['to_code'];
    fromCurrencyName = json['from_currency_name'];
    toCurrencyName = json['to_currency_name'];
    amount = json['amount'];
    convertedAmount = json['convertedAmount'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['from_code'] = fromCode;
    data['to_code'] = toCode;
    data['from_currency_name'] = fromCurrencyName;
    data['to_currency_name'] = toCurrencyName;
    data['amount'] = amount;
    data['convertedAmount'] = convertedAmount;
    data['date'] = date;
    return data;
  }
}