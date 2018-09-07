package data.state;

import redux.Redux;
import redux.Store;
import redux.StoreBuilder.*;

import data.types.Note;

typedef AppState = {
    var api: APIState;
    var auth: AuthState;
    var notes: IDMapState<Note>;
    var sortfilter:SortFilterState;
}

class AppStateTools {
    public static function initialize():Store<AppState> {
        var rootReducer = Redux.combineReducers({
            api: mapReducer(data.actions.APIActions, new data.reducers.APIReducer()),
            auth: mapReducer(data.actions.AuthActions, new data.reducers.AuthReducer()),
            notes: mapReducer(data.actions.NoteActions, new data.reducers.NoteReducer()),
            sortfilter: mapReducer(data.actions.SortFilterActions, new data.reducers.SortFilterReducer()),
        });
        return createStore(rootReducer);
    }
}
