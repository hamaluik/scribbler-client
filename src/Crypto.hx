import sodium.Sodium;
import js.html.Uint8Array;
import js.html.TextEncoder;
import js.html.TextDecoder;
import js.Promise;
import js.Browser;

enum CryptoResult {
    Ok;
    NotLoaded;
    NoSalt;
    NoKey;
}

enum KeyResult {
    Ok(server_key:Base64String);
    Error(result:CryptoResult);
}

enum CipherResult {
    Ok(cipher_text:Uint8Array, nonce:Uint8Array);
    Error(result:CryptoResult);
}

enum DecipherResult {
    Ok(result:String);
    Error(result:CryptoResult);
}

class Crypto {
    static var sodium:Sodium;
    static var encoder:TextEncoder = new TextEncoder();
    static var decoder:TextDecoder = new TextDecoder();

    static var salt:Uint8Array;
    static var key:Uint8Array;

    public static function init():Promise<{}> {
        return new Promise<{}>(function(resolve:{}->Void, reject:Dynamic->Void):Void {
            Reflect.setField(Browser.window, "sodium", {
                onload: function(sodium:Sodium) {
                    Crypto.sodium = sodium;
                    resolve({});
                }
            });
        });
    }

    public static function store_salt(salt:Base64String):Void {
        Crypto.salt = salt.to_bytes();
    }

    public static function _generate_salt():CryptoResult {
        if(sodium == null) return CryptoResult.NotLoaded;
        Crypto.salt = sodium.randombytes_buf(sodium.crypto_pwhash_SALTBYTES);
        return CryptoResult.Ok;
    }

    public static function calculate_key(pw:String):KeyResult {
        if(sodium == null) return KeyResult.Error(CryptoResult.NotLoaded);
        if(salt == null) return KeyResult.Error(CryptoResult.NoSalt);
        var full_key:Uint8Array = sodium.crypto_pwhash(sodium.crypto_secretbox_KEYBYTES * 2, encoder.encode(pw), salt, sodium.crypto_pwhash_OPSLIMIT_INTERACTIVE, sodium.crypto_pwhash_MEMLIMIT_INTERACTIVE, sodium.crypto_pwhash_ALG_DEFAULT);
        Crypto.key = full_key.subarray(0, sodium.crypto_secretbox_KEYBYTES);
        var server_key:Uint8Array = full_key.subarray(sodium.crypto_secretbox_KEYBYTES);
        return KeyResult.Ok(server_key);
    }

    public static function encrypt(message:String):CipherResult {
        if(sodium == null) return CipherResult.Error(CryptoResult.NotLoaded);
        if(key == null) return CipherResult.Error(CryptoResult.NoKey);
        var nonce:Uint8Array = sodium.randombytes_buf(sodium.crypto_secretbox_NONCEBYTES);
        var cipher_text:Uint8Array = sodium.crypto_secretbox_easy(encoder.encode(message), nonce, key);
        return CipherResult.Ok(cipher_text, nonce);
    }

    public static function decrypt(cipher_text:Uint8Array, nonce:Uint8Array):DecipherResult {
        if(sodium == null) return DecipherResult.Error(CryptoResult.NotLoaded);
        if(key == null) return DecipherResult.Error(CryptoResult.NoKey);
        return DecipherResult.Ok(decoder.decode(sodium.crypto_secretbox_open_easy(cipher_text, nonce, key)));
    }
}