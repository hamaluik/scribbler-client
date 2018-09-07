package data.state;

import redux.Redux;
import redux.Store;
import redux.StoreBuilder.*;

import data.types.Note;

typedef AppState = {
    var api: APIState;
    var auth: AuthState;
    var notes: IDMapState<Note>;
    var sort:SortState;
}

class AppStateTools {
    public static function initialize():Store<AppState> {
        var rootReducer = Redux.combineReducers({
            api: mapReducer(data.actions.APIActions, new data.reducers.APIReducer()),
            auth: mapReducer(data.actions.AuthActions, new data.reducers.AuthReducer()),
            notes: mapReducer(data.actions.NoteActions, new data.reducers.NoteReducer()),
            sort: mapReducer(data.actions.SortActions, new data.reducers.SortReducer()),
        });
        return createStore(rootReducer);
    }
}
