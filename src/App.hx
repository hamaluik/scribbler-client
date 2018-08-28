import js.html.Uint8Array;
import haxe.ds.IntMap;
import js.Promise;
import js.Browser;
import js.html.Console;
import mithril.M;
import redux.Store;
import data.state.AppState;
import js.html.ScriptElement;
import js.html.MessageEvent;
import js.html.Worker;

class App {
    public static var console:Console;
    public static var store:Store<AppState>;
    static var worker:js.html.Worker;
    static var nextID:Int;
    static var workerResolvers:IntMap<{resolve:Dynamic->Void, reject:Dynamic->Void}>;

    public static function main() {
        // if we are the web worker, move over there!
        if(try Browser.document == null catch (e:Dynamic) true) {
            CryptoWorker.init();
            return;
        }
        console = Browser.console;
        nextID = 0;
        workerResolvers = new IntMap<{resolve:Dynamic->Void, reject:Dynamic->Void}>();

        // initialize the web worker
        var scriptPath = cast(Browser.document.currentScript, ScriptElement).src;
        worker = new Worker(scriptPath);
        worker.onmessage = onMessageFromWorker;
        console.debug("initialized worker", worker);

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

    public static function postMessage(message:WorkerMessage, data:Dynamic):Promise<Dynamic> {
        var id:Int = nextID;
        nextID++;
        var payload:WorkerPayload = {
            id: id,
            message: message,
            data: data
        };
        console.debug("setting up post message with payload", payload);
        return new Promise(function(resolve:Dynamic->Void, reject:String->Void):Void {
            workerResolvers.set(id, {
                resolve: resolve,
                reject: reject
            });
            console.debug("posting payload", payload);
            worker.postMessage(payload);
            console.debug("posted message with resolvers", workerResolvers.get(id));
        });
    }

    static function onMessageFromWorker(e:MessageEvent) {
		var payload:AppPayload = e.data;
        console.debug("received message from worker", payload);
		switch(payload.message) {
            case AppMessage.Info: {
                console.info(payload.data);
                if(payload.id != -1) {
                    var resolvers = workerResolvers.get(payload.id);
                    resolvers.resolve(payload.data);
                    workerResolvers.remove(payload.id);
                }
            }
            case AppMessage.Error: {
                console.error(payload.data);
                if(payload.id != -1) {
                    var resolvers = workerResolvers.get(payload.id);
                    resolvers.reject(payload.data);
                    workerResolvers.remove(payload.id);
                }
            }

            case AppMessage.GeneratedSaltAndKey: {
                var resolvers = workerResolvers.get(payload.id);
                resolvers.resolve({
                    salt: cast(payload.data.salt, Uint8Array),
                    server_key: cast(payload.data.server_key, Uint8Array)
                });
                workerResolvers.remove(payload.id);
            }
        }
    }
}