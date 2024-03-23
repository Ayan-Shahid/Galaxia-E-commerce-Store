import 'package:galaxia/store/cart_state.dart';
import 'package:galaxia/store/galaxia_product.dart';

CartState cartReducer(CartState state, dynamic action) {
  if (action.type == CartStateActions.addToCart) {
    List<GalaxiaCartProduct> list = List.from(state.items);
    bool found = list.contains(action.payload);

    if (found) {
      int index = list.indexWhere((element) => element == action.payload);

      if (list[index].size == action.payload.size &&
          list[index].color == action.payload.color) {
        list[index].quantity = action.payload.quantity + list[index].quantity;
      }
    } else {
      list.add(action.payload);
    }
    double? total =
        state.total + (action.payload.price * action.payload.quantity);
    return CartState(
        items: list,
        total: total,
        subTotal: total,
        quantity: state.quantity + 1);
  } else if (action.type == CartStateActions.removeFromCart) {
    List<GalaxiaCartProduct> list = List.from(state.items);
    list.remove(action.payload);
    double total =
        state.total - (action.payload.price * action.payload.quantity);
    return CartState(
        items: list,
        total: total,
        subTotal: total,
        quantity: state.quantity - 1);
  } else if (action.type == CartStateActions.updateQuantity) {
    List<GalaxiaCartProduct> list = List.from(state.items);
    double total = 0;

    for (GalaxiaCartProduct element in list) {
      if (element.id == action.payload.id) {
        element.quantity = action.payload.quantity;
      }
      total = total + (element.price! * element.quantity!);
    }

    return CartState(
        items: list, total: total, subTotal: total, quantity: state.quantity);
  } else if (action.type == CartStateActions.clear) {
    List<GalaxiaCartProduct> list = [];
    double total = 0;

    return CartState(items: list, total: total, subTotal: total, quantity: 0);
  }
  return state;
}
