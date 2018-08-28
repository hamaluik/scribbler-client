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
        // if we are the web worker, move over there!
        if(try Browser.document == null catch (e:Dynamic) true) {
            Worker.init();
            return;
        }

        // initialize the web worker
        var scriptPath = cast(Browser.document.currentScript, ScriptElement).src;
        var worker = new js.html.Worker(scriptPath);
        worker.onmessage = onMessageFromWorker;

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

    static function onMessageFromWorker(e:MessageEvent) {
        
    }
}