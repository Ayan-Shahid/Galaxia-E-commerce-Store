import 'package:galaxia/store/wishlist_state.dart';

WishListState wishListReducer(WishListState state, dynamic action) {
  if (action.type == WishListStateActions.add) {
    if (state.list.contains(action.payload)) {
      return WishListState(list: state.list);
    }
    List<WishListItem> newList = List.from(state.list)..add(action.payload);
    return WishListState(list: newList);
  } else if (action.type == WishListStateActions.remove) {
    WishListItem item =
        state.list.firstWhere((element) => element.uid == action.payload.uid);
    List<WishListItem> newList = List.from(state.list)..remove(item);

    return WishListState(list: newList);
  }
  return state;
}
