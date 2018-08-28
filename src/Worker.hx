import js.html.DedicatedWorkerGlobalScope;
import js.html.MessageEvent;

class Worker {
	static var workerScope:DedicatedWorkerGlobalScope;

	public static function init():Void {
		// Find the worker "self"
		workerScope = untyped self;

		// Setup the worker message handler:
		workerScope.onmessage = onMessageFromParent;
	}

	static function onMessageFromParent(e:MessageEvent) {
	}
}
