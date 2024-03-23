import 'package:galaxia/store/galaxia_product.dart';

class CartState {
  final List<GalaxiaCartProduct> items;
  final double subTotal;
  final double total;
  final int quantity;
  const CartState(
      {this.items = const [],
      this.subTotal = 0,
      this.total = 0,
      this.quantity = 0});
}

enum CartStateActions { addToCart, removeFromCart, updateQuantity, clear }

class CartStateAction {
  CartStateActions? type;
  dynamic payload;

  CartStateAction({this.type, this.payload});
}
