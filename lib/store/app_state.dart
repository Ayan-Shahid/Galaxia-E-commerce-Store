import 'package:galaxia/store/address_book_state.dart';
import 'package:galaxia/store/cart_state.dart';
import 'package:galaxia/store/galaxia_product.dart';
import 'package:galaxia/store/order_state.dart';
import 'package:galaxia/store/payment_methods_state.dart';
import 'package:galaxia/store/review_state.dart';
import 'package:galaxia/store/wishlist_state.dart';

class AppState {
  final List<GalaxiaProduct> inventory;
  final CartState cart;
  final OrderState orders;
  final WishListState wishlist;
  final ReviewState reviews;
  final AddressBookState addressBook;
  final PaymentMethodsState paymentMethods;

  AppState(
      {this.inventory = const [],
      this.wishlist = const WishListState(),
      this.reviews = const ReviewState(),
      this.orders = const OrderState(),
      this.cart = const CartState(),
      this.paymentMethods = const PaymentMethodsState(),
      this.addressBook = const AddressBookState()});
}

enum AppStateActions { addProduct, removeProduct, addInventory }

class AppStateAction {
  AppStateActions? type;
  dynamic payload;

  AppStateAction({this.type, this.payload});
}
