package data.reducers;

import data.actions.AuthActions;
import data.state.AuthState;

class AuthReducer implements redux.IReducer<AuthActions, AuthState> {
    public var initState:AuthState = {
        token: None
    };

    public function reduce(state: AuthState, action: AuthActions): AuthState {
        var blank:AuthState = { token: None };
        return switch(action) {
            case AuthActions.SignIn(token): {
                var newState:AuthState = {
                    token: Some(token)
                };
                js.Object.assign(blank, state, newState);
            }
            case AuthActions.SignOut: {
                var newState:AuthState = {
                    token: None
                };
                js.Object.assign(blank, state, newState);
            }
        };
    }

    public function new() {}
}