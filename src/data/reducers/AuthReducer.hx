package data.reducers;

import api.Auth;
import data.actions.AuthActions;
import data.state.AuthState;

class AuthReducer implements redux.IReducer<AuthActions, AuthState> {
    public var initState:AuthState = {
        token: None,
        signed_up: false
    };

    public function reduce(state: AuthState, action: AuthActions): AuthState {
        var blank:AuthState = { token: None, signed_up: false };
        return switch(action) {
            case AuthActions.SignUp: {
                var newState = {
                    signed_up: true
                };
                js.Object.assign(blank, state, newState);
            }

            case AuthActions.SignIn(token): {
                var newState = {
                    token: Option.Some(token)
                };
                js.Object.assign(blank, state, newState);
            }

            case AuthActions.Refresh(token): {
                var newState = {
                    token: Option.Some(token)
                };
                js.Object.assign(blank, state, newState);
            }

            case AuthActions.SignOut: {
                Auth.stop_refresh();
                var newState = {
                    token: Option.None
                };
                js.Object.assign(blank, state, newState);
            }
        };
    }

    public function new() {}
}