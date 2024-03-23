import 'package:galaxia/store/app_reducer.dart';
import 'package:redux/redux.dart';

import 'package:galaxia/store/app_state.dart';
import 'package:redux_thunk/redux_thunk.dart';

final galaxiaStore = Store<AppState>(appReducer,
    initialState: AppState(), middleware: [thunkMiddleware]);
