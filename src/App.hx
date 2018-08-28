import js.Browser;
import js.html.Console;
import mithril.M;
import redux.Store;
import data.state.AppState;
import js.html.ScriptElement;
import js.html.MessageEvent;

class App {
    public static var console:Console = Browser.console;
    public static var store:Store<AppState>;

    public static function main() {
        // initialize crypto
        Crypto.init()
            .then(function(_) {
                console.info("sodium initialized!");
            })
            .catchError(function(err) {
                console.error("failed to initialize sodium", err);
            });

        // initialize the data store
        store = data.state.AppState.AppStateTools.initialize();

        // and get the API setting...
        api.API.getRoot()
            .then(function(_) {
                App.console.log("API request success, root:", store.getState().api.root);
            })
            .catchError(function(err:Dynamic) {
                App.console.error("Failed to get API root:", err);
            });

        // and initialize routing...
        M.route(js.Browser.document.body, '/', {
            '/': new ui.routes.Default(),
            '/signin': new ui.routes.SignIn(),
            '/signup': new ui.routes.SignUp(),
        });
    }
}