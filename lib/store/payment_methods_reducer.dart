import 'package:galaxia/store/payment_methods_state.dart';

PaymentMethodsState paymentMethodsReducer(
    PaymentMethodsState state, dynamic action) {
  if (action.type == PaymentMethodsStateActions.add) {
    List<PaymentMethodItem> list = List.from(state.items);
    if (action.payload.isDefault == true) {
      PaymentMethodItem item = list.firstWhere(
        (element) => element.isDefault == true,
        orElse: () => PaymentMethodItem(
            id: "",
            isDefault: false,
            name: "",
            expMonth: "",
            expYear: "",
            last4: "",
            type: ""),
      );
      if (item.isDefault == true) {
        int index = list.indexOf(item);
        list[index].isDefault = false;
      }
    }
    list.add(action.payload);

    return PaymentMethodsState(items: list);
  } else if (action.type == PaymentMethodsStateActions.remove) {
    List<PaymentMethodItem> list = List.from(state.items);
    list.remove(action.payload);

    return PaymentMethodsState(items: list);
  }

  return state;
}
