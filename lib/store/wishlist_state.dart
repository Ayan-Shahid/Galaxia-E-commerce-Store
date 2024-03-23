class WishListItem {
  final String? uid;
  final String? userId;
  final String? productId;

  const WishListItem(
      {required this.uid, required this.userId, required this.productId});
}

class WishListState {
  final List<WishListItem> list;

  const WishListState({this.list = const []});
}

enum WishListStateActions { add, remove }

class WishListStateAction {
  WishListStateActions? type;
  dynamic payload;

  WishListStateAction({this.type, this.payload});
}
