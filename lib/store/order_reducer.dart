import 'package:galaxia/store/galaxia_product.dart';
import 'package:galaxia/store/order_state.dart';

OrderState orderReducer(OrderState state, dynamic action) {
  if (action.type == OrderStateActions.add) {
    List<GalaxiaCartProduct> list = List.from(state.items);

    list.add(action.payload);

    return OrderState(
      items: list,
    );
  } else if (action.type == OrderStateActions.remove) {
    List<GalaxiaCartProduct> list = List.from(state.items);
    list.remove(action.payload);

    return OrderState(
      items: list,
    );
  }
  return state;
}
