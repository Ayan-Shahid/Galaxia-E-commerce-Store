import 'package:galaxia/store/galaxia_product.dart';

class OrderState {
  final List<GalaxiaCartProduct> items;

  const OrderState({
    this.items = const [],
  });
}

enum OrderStateActions { add, remove }

class OrderStateAction {
  OrderStateActions? type;
  dynamic payload;

  OrderStateAction({this.type, this.payload});
}
