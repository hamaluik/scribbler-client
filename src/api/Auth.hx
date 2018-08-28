package api;

import mithril.M;

class Auth {
    public static function signIn(email:String, password:String):APIPromise {
        return new APIPromise(function(resolve, reject) {
            if(!App.store.getState().api.loaded) {
                reject('api store not loaded!');
                return;
            }

            var email_pass:String = '$email:$password';
            var email_pass_hash = haxe.crypto.Base64.encode(haxe.io.Bytes.ofString(email_pass));

            M.request(App.store.getState().api.root + "/auth", {
                method: 'GET',
                async: true,
                headers: {
                    Authorization: "Basic " + email_pass_hash
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
}