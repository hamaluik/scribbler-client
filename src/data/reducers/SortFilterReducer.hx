package data.reducers;

import data.actions.SortFilterActions;
import data.state.SortFilterState;

class SortFilterReducer implements redux.IReducer<SortFilterActions, SortFilterState> {
    public var initState:SortFilterState = {
        sort: SortType.Date(SortDirection.Desc),
        filter: None
    };

    public function reduce(state: SortFilterState, action: SortFilterActions): SortFilterState {
        var blank:SortFilterState = { sort: SortType.Date(SortDirection.Desc), filter: None };
        return switch(action) {
            case SortByTitle(direction): {
                var newState:SortFilterState = {
                    sort: SortType.Title(direction),
                    filter: state.filter
                };
                js.Object.assign(blank, state, newState);
            }

            case SortByDate(direction): {
                var newState:SortFilterState = {
                    sort: SortType.Date(direction),
                    filter: state.filter
                };
                js.Object.assign(blank, state, newState);
            }

            case Filter(query): {
                var newState:SortFilterState = {
                    sort: state.sort,
                    filter: StringTools.trim(query).length < 1 ? None : Some(query)
                };
                js.Object.assign(blank, state, newState);
            }

            case ClearFilter: {
                var newState:SortFilterState = {
                    sort: state.sort,
                    filter: None
                };
                js.Object.assign(blank, state, newState);
            }
        };
    }

    public function new() {}
}