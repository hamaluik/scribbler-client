package api;

import js.html.Uint8Array;
import mithril.M;

class Auth {
    public static function signIn(name:String, password:String):APIPromise {
        return new APIPromise(function(resolve, reject) {
            if(!App.store.getState().api.loaded) {
                reject('api store not loaded!');
                return;
            }

            // TODO: crypto!
            var name_pass:String = '$name:$password';
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
            });
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

            // generate a salt and key to use for signing up
            var salt:Base64String = switch(Crypto.generate_salt()) {
                case Ok(salt): salt;
                case Err(e): {
                    reject('unable to generate salt!');
                    return;
                }
            };

            // generate a key
            var server_key:Base64String = switch(Crypto.calculate_key('${name}:${password}')) {
                case Ok(key): key;
                case Err(e): {
                    reject('unable to generate key!');
                    return;
                }
            };

            // now we can ping the server with our sign up
            M.request(App.store.getState().api.root + "/auth/", {
                method: 'POST',
                async: true,
                data: {
                    name: name,
                    server_key: server_key,
                    salt: salt,
                    registration_key: registration_key
                }
            })
            .then(function(_) {
                App.console.debug("Sign up successful!");
                resolve({});
            })
            .catchError(function(err:Dynamic) {
                App.console.error("Error signing up:", err);
                reject(err);
            });
        });
    }
}