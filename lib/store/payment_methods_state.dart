class PaymentMethodItem {
  String? id;
  String? last4;
  String? name;
  String? expMonth;
  String? expYear;
  String? type;
  bool? isDefault;

  PaymentMethodItem({
    required this.id,
    required this.isDefault,
    required this.name,
    required this.expMonth,
    required this.expYear,
    required this.last4,
    required this.type,
  });
}

class PaymentMethodsState {
  final List<PaymentMethodItem> items;

  const PaymentMethodsState({this.items = const []});
}

enum PaymentMethodsStateActions { add, remove }

class PaymentMethodsStateAction {
  PaymentMethodsStateActions? type;
  dynamic payload;

  PaymentMethodsStateAction({this.type, this.payload});
}
