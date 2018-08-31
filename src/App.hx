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
import markdownit.MarkdownIt;
import crypto.CryptoWorker;
import crypto.WorkerMessage;
import crypto.WorkerPayload;
import crypto.AppMessage;
import crypto.AppPayload;

class App {
    public static var console:Console;
    public static var store:Store<AppState>;
    public static var markdown:MarkdownIt;
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

        // initialize the markdown parser
        markdown = untyped window.markdownit();

        // initialize the data store
        store = data.state.AppState.AppStateTools.initialize();

        // and get the API setting...
        api.API.getRoot()
            .then(function(_) {
                App.console.info("api root:", store.getState().api.root);
            })
            .catchError(function(err:Dynamic) {
                App.console.error("failed to get API root:", err);
            });

        // and initialize routing...
        M.route(js.Browser.document.body, '/view', {
            '/signin': new ui.routes.SignIn(),
            '/signup': new ui.routes.SignUp(),
            '/view': new ui.routes.View(),
            '/new': new ui.routes.New(),
            '/edit': new ui.routes.Edit(),
            '/rename': new ui.routes.Rename(),
            '/delete': new ui.routes.Delete(),
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
        return new Promise(function(resolve:Dynamic->Void, reject:String->Void):Void {
            workerResolvers.set(id, {
                resolve: resolve,
                reject: reject
            });
            worker.postMessage(payload);
        });
    }

    static function onMessageFromWorker(e:MessageEvent) {
		var payload:AppPayload = e.data;
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

            case AppMessage.GeneratedKey: {
                var resolvers = workerResolvers.get(payload.id);
                resolvers.resolve({
                    server_key: cast(payload.data.server_key, Uint8Array)
                });
                workerResolvers.remove(payload.id);
            }
        }
    }
}