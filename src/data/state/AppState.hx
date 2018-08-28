package data.state;

import redux.Redux;
import redux.Store;
import redux.StoreBuilder.*;

import data.actions.APIActions;
import data.actions.AuthActions;

typedef AppState = {
    var api: APIState;
    var auth: AuthState;
}

class AppStateTools {
    public static function initialize():Store<AppState> {
        var rootReducer = Redux.combineReducers({
            api: mapReducer(data.actions.APIActions, new data.reducers.APIReducer()),
            auth: mapReducer(data.actions.AuthActions, new data.reducers.AuthReducer()),
        });
        return createStore(rootReducer);
    }
}
