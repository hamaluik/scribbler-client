package crypto;

import js.html.Uint8Array;
import js.html.DedicatedWorkerGlobalScope;
import js.html.MessageEvent;
import util.Base64String;

class CryptoWorker {
	static var initialized:Bool = false;
	static var workerScope:DedicatedWorkerGlobalScope;

	public static function init():Void {
		// Find the worker "self"
		workerScope = untyped self;

		// Setup the worker message handler:
		workerScope.onmessage = onMessageFromParent;

		// load sodium
		workerScope.importScripts('sodium.js');

		// initialize the crypto
		if(!Crypto.init(workerScope)) {
			workerScope.postMessage({
				id: -1,
				message: AppMessage.Error,
				data: "failed to initialize sodium!",
			});
		}
		else {
			workerScope.postMessage({
				id: -1,
				message: AppMessage.Info,
				data: "initialized sodium!",
			});
			initialized = true;
		}
	}

	static function onMessageFromParent(e:MessageEvent):Void {
		if(!initialized) {
			workerScope.postMessage({
				id: -1,
				message: AppMessage.Error,
				data: "can't process message—crypto not initialized!",
			});
			return;
		}

		var payload:WorkerPayload = e.data;
		switch(payload.message) {
			case WorkerMessage.GenerateSaltAndKey: {
				// generate a salt
				var salt:Uint8Array = switch(Crypto.generate_salt()) {
					case Ok(salt): salt;
					case Err(e): {
						workerScope.postMessage({
							id: payload.id,
							message: AppMessage.Error,
							data: "failed to generate salt"
						});
						return;
					}
				};

				// generate a key
				var server_key:Uint8Array = switch(Crypto.calculate_key('${payload.data.name}:${payload.data.password}', salt)) {
					case Ok(key): key;
					case Err(e): {
						workerScope.postMessage({
							id: payload.id,
							message: AppMessage.Error,
							data: "failed to generate key"
						});
						return;
					}
				};

				// return!
				workerScope.postMessage({
					id: payload.id,
					message: AppMessage.GeneratedSaltAndKey,
					data: {
						salt: salt,
						server_key: server_key
					}
				}, [
					salt.buffer,
					server_key.buffer
				]);
			}

			case WorkerMessage.GenerateKey: {
				var salt:Base64String = payload.data.salt;
				var server_key:Uint8Array = switch(Crypto.calculate_key('${payload.data.name}:${payload.data.password}', salt.to_bytes())) {
					case Ok(key): key;
					case Err(e): {
						workerScope.postMessage({
							id: payload.id,
							message: AppMessage.Error,
							data: "failed to generate key"
						});
						return;
					}
				};

				// return!
				workerScope.postMessage({
					id: payload.id,
					message: AppMessage.GeneratedKey,
					data: {
						server_key: server_key
					}
				}, [
					server_key.buffer
				]);
			}
		}
	}
}
