import 'package:galaxia/store/address_book_reducer.dart';
import 'package:galaxia/store/app_state.dart';
import 'package:galaxia/store/cart_reducer.dart';
import 'package:galaxia/store/galaxia_product.dart';
import 'package:galaxia/store/order_reducer.dart';
import 'package:galaxia/store/payment_methods_reducer.dart';
import 'package:galaxia/store/review_reducer.dart';
import 'package:galaxia/store/wishlist_reducer.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action.type == AppStateActions.addInventory) {
    List<GalaxiaProduct> inventory = List.from(state.inventory);
    inventory.add(action.payload);
    return AppState(inventory: inventory);
  }

  return AppState(
    inventory: state.inventory,
    cart: cartReducer(state.cart, action),
    wishlist: wishListReducer(state.wishlist, action),
    orders: orderReducer(state.orders, action),
    reviews: reviewReducer(state.reviews, action),
    paymentMethods: paymentMethodsReducer(state.paymentMethods, action),
    addressBook: addressBookReducer(state.addressBook, action),
  );
}
