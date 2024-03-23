import 'package:galaxia/store/review_state.dart';

ReviewState reviewReducer(ReviewState state, dynamic action) {
  if (action.type == ReviewStateActions.add) {
    List<ReviewItem> items = List.from(state.list);

    items.add(action.payload);
    return ReviewState(list: items);
  }

  return state;
}
