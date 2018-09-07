package data.state;

enum SortDirection {
    Asc;
    Desc;
}

enum SortType {
    Title(direction:SortDirection);
    Date(direction:SortDirection);
}

typedef SortState = {
    var type:SortType;
}
