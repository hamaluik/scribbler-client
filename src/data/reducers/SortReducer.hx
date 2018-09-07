package data.reducers;

import data.actions.SortActions;
import data.state.SortState;

class SortReducer implements redux.IReducer<SortActions, SortState> {
    public var initState:SortState = {
        type: SortType.Date(SortDirection.Desc)
    };

    public function reduce(state: SortState, action: SortActions): SortState {
        var blank:SortState = { type: SortType.Date(SortDirection.Desc) };
        return switch(action) {
            case SortActions.SortByTitle(direction): {
                var newState = {
                    type: SortType.Title(direction)
                };
                js.Object.assign(blank, state, newState);
            }

            case SortActions.SortByDate(direction): {
                var newState = {
                    type: SortType.Date(direction)
                };
                js.Object.assign(blank, state, newState);
            }
        };
    }

    public function new() {}
}