class AddressBookItem {
  String? id;
  String? uid;
  String? name;
  String? country;
  String? state;
  String? city;
  String? postalCode;
  String? line1;
  String? line2;
  bool isDefault;

  AddressBookItem(
      {required this.id,
      required this.uid,
      required this.name,
      required this.country,
      required this.state,
      required this.city,
      required this.postalCode,
      required this.line1,
      required this.line2,
      required this.isDefault});
}

class AddressBookState {
  final List<AddressBookItem> items;

  const AddressBookState({this.items = const []});
}

enum AddressBookStateActions { add, remove, clear }

class AddressBookStateAction {
  AddressBookStateActions? type;
  dynamic payload;

  AddressBookStateAction({this.type, this.payload});
}
