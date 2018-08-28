package data.state;

typedef AuthState = {
    var token: Option<String>;
    var signed_up: Bool;
}