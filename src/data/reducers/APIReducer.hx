package data.reducers;

import data.actions.APIActions;
import data.state.APIState;

class APIReducer implements redux.IReducer<APIActions, APIState> {
    public var initState:APIState = {
        loaded: false,
        root: ""
    };

    public function reduce(state: APIState, action: APIActions): APIState {
        var blank:APIState = { loaded: false, root: "" };
        return switch(action) {
            case APIActions.SetRoot(root): {
                var newState:APIState = {
                    loaded: true,
                    root: root
                };
                js.Object.assign(blank, state, newState);
            }
        };
    }

    public function new() {}
}