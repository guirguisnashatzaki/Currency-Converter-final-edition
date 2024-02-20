class SupportedCurrency {
  String? code;
  String? currencyName;
  String? flag;

  SupportedCurrency({this.code, this.flag, this.currencyName});

  SupportedCurrency.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    currencyName = json['currencyName'];
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['currencyName'] = currencyName;
    data['flag'] = flag;
    return data;
  }
}