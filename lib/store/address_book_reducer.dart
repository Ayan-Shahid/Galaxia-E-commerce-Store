import 'package:galaxia/store/address_book_state.dart';

AddressBookState addressBookReducer(AddressBookState state, dynamic action) {
  if (action.type == AddressBookStateActions.add) {
    List<AddressBookItem> newList = List.from(state.items)..add(action.payload);
    return AddressBookState(items: newList);
  } else if (action.type == AddressBookStateActions.remove) {
    List<AddressBookItem> newList = List.from(state.items)
      ..remove(action.payload);
    return AddressBookState(items: newList);
  }
  return state;
}
