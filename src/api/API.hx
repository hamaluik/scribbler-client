package api;

import mithril.M;
import js.Promise;

class API {
    public static function getRoot():APIPromise {
        return new Promise(function(resolve:{}->Void, reject:Dynamic->Void):Void {
            M.request("/api.json", {
                method: "GET",
                async: true
            })
            .then(function(api:{ root: String }) {
                if(api != null && api.root != null) {
                    App.store.dispatch(data.actions.APIActions.SetRoot(api.root));
                    resolve({});
                }
                else {
                    throw "api.json doesn't define `root`!";
                }
            })
            .catchError(function(err:Dynamic):Void {
                js.Browser.console.error("failed to get API root!");
                reject(err);
            });
        });
    }
}