package data.actions;

import data.state.SortState.SortDirection;

enum SortActions {
    SortByTitle(direction:SortDirection);
    SortByDate(direction:SortDirection);
}