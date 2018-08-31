package api;

import haxe.Timer;
import data.actions.AuthActions;
import js.html.Uint8Array;
import mithril.M;
import crypto.WorkerMessage;
import util.Base64String;

class Auth {
    static var refresh_timer:Timer;

    public static function signIn(name:String, password:String):APIPromise {
        return new APIPromise(function(resolve, reject) {
            if(!App.store.getState().api.loaded) {
                reject('api store not loaded!');
                return;
            }

            // truncate the name and password
            if(name.length > 128) {
                name = name.substr(0, 128);
            }
            if(password.length > 128) {
                password = password.substr(0, 128);
            }

            // query the salt from the server
            M.request(App.store.getState().api.root + "/auth/params/" + StringTools.urlEncode(name), {
                method: 'GET',
                async: true
            })
            .then(function(result:{salt:Base64String}) {
                // now calculate the key
                return App.postMessage(WorkerMessage.GenerateKey, {
                    salt: result.salt,
                    name: name,
                    password: password
                });
            })
            .then(function(result:{server_key:Uint8Array}) {
                // now attempt sign in
                var server_key:Base64String = Base64String.from_bytes(result.server_key);
                var name_pass:String = '$name:$server_key';
                var name_pass_hash = haxe.crypto.Base64.encode(haxe.io.Bytes.ofString(name_pass));
                return M.request(App.store.getState().api.root + "/auth", {
                    method: 'GET',
                    async: true,
                    headers: {
                        Authorization: "Basic " + name_pass_hash
                    }
                });
            })
            .then(function(credentials: { token: String }) {
                if(credentials != null && credentials.token != null) {
                    App.store.dispatch(AuthActions.SignIn(credentials.token));
                    refresh_timer = new Timer(1000 * 60 * 3);
                    refresh_timer.run = refresh_token;
                    resolve({});
                }
                else {
                    throw 'invalid server response!';
                }
            })
            .catchError(function(err) {
                App.console.error("error signing in", err);
                reject(err);
            });
        });
    }

    @:allow(data.reducers.AuthReducer)
    static function stop_refresh():Void {
        if(refresh_timer == null) return;
        refresh_timer.stop();
        refresh_timer = null;
        App.console.info("sign in refresh cancelled!");
    }

    static function refresh_token():Void {
        // stop if we no longer have a token for whatever reason
        if(App.store.getState().auth.token.match(None)) {
            stop_refresh();
            return;
        }

        var token:String = switch(App.store.getState().auth.token) {
            case Some(t): t;
            case None: { stop_refresh(); return; }
        };

        M.request(App.store.getState().api.root + "/auth/refresh", {
            method: 'GET',
            async: true,
            headers: {
                Authorization: "Bearer " + token
            },
        })
        .then(function(credentials: { token: String }) {
            if(credentials != null && credentials.token != null) {
                App.store.dispatch(AuthActions.Refresh(credentials.token));
                App.console.info("credentials refreshed");
            }
            else {
                stop_refresh();
                throw 'invalid server response!';
            }
        })
        .catchError(function(err) {
            stop_refresh();
            App.console.error("error refreshing sign in!", err);
        });
    }

    public static function signUp(name:String, password:String, registration_key:String):APIPromise {
        return new APIPromise(function(resolve, reject) {
            if(!App.store.getState().api.loaded) {
                reject('api store not loaded!');
                return;
            }

            // truncate the name and password
            if(name.length > 128) {
                name = name.substr(0, 128);
            }
            if(password.length > 128) {
                password = password.substr(0, 128);
            }

            // get our crypto to generate the salt and key
            App.postMessage(WorkerMessage.GenerateSaltAndKey, {
                name: name,
                password: password
            })
            .then(function(result:{salt:Uint8Array, server_key:Uint8Array}) {
                return M.request(App.store.getState().api.root + "/auth", {
                    method: 'POST',
                    async: true,
                    data: {
                        name: name,
                        server_key: Base64String.from_bytes(result.server_key),
                        salt: Base64String.from_bytes(result.salt),
                        registration_key: registration_key
                    }
                });
            }).then(function(_) {
                App.store.dispatch(AuthActions.SignUp);
                resolve({});
            })
            .catchError(function(err:Dynamic) {
                App.console.error("Error signing up:", err);
                reject(err);
            });
        });
    }

    public static function signOut():Void {
        App.store.dispatch(AuthActions.SignOut);
    }
}