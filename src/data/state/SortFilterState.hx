package data.state;

enum SortDirection {
    Asc;
    Desc;
}

enum SortType {
    Title(direction:SortDirection);
    Date(direction:SortDirection);
}

typedef SortFilterState = {
    var sort:SortType;
    var filter:Option<String>;
}
