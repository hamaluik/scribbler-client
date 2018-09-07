package data.actions;

import data.state.SortFilterState.SortDirection;

enum SortFilterActions {
    SortByTitle(direction:SortDirection);
    SortByDate(direction:SortDirection);
    Filter(query:String);
    ClearFilter;
}