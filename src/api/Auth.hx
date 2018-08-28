package api;

import data.actions.AuthActions;
import js.html.Uint8Array;
import mithril.M;

class Auth {
    public static function signIn(name:String, password:String):APIPromise {
        return new APIPromise(function(resolve, reject) {
            if(!App.store.getState().api.loaded) {
                reject('api store not loaded!');
                return;
            }

            /*var name_pass:String = '$name:$password';
            var name_pass_hash = haxe.crypto.Base64.encode(haxe.io.Bytes.ofString(name_pass));

            M.request(App.store.getState().api.root + "/auth", {
                method: 'GET',
                async: true,
                headers: {
                    Authorization: "Basic " + name_pass_hash
                }
            })
            .then(function(credentials: { token: String }) {
                if(credentials != null && credentials.token != null) {
                    App.store.dispatch(data.actions.AuthActions.SignIn(credentials.token));
                    resolve({});
                }
                else {
                    throw 'Invalid response!';
                }
            })
            .catchError(function(err:Dynamic) {
                reject(err);
            });*/
            reject('Not implemented yet');
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
                return M.request(App.store.getState().api.root + "/auth/", {
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
                App.console.debug("Sign up successful!");
                App.store.dispatch(AuthActions.SignUp);
                resolve({});
            })
            .catchError(function(err:Dynamic) {
                App.console.error("Error signing up:", err);
                reject(err);
            });
        });
    }
}