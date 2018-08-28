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

            App.postMessage(WorkerMessage.GenerateSaltAndKey, { name: name, password: password }).then(function(result:{salt:Uint8Array, server_key:Uint8Array}) {
                var salt:Base64String = result.salt;
                var server_key:Base64String = result.server_key;
                App.console.info("Generated salt and key:", salt, server_key);
                resolve({});
            })
            .catchError(function(message:String) {
                reject(message);
            });
        });
    }
}