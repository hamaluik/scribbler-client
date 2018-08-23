import sodium.Sodium;
import js.html.Uint8Array;
import js.html.TextEncoder;
import js.html.TextDecoder;
import js.Promise;
import js.Browser;

enum CipherResult {
    Ok(cipher_text:Uint8Array, nonce:Uint8Array);
    Error(result:CryptoResult);
}

enum DecipherResult {
    Ok(result:String);
    Error(result:CryptoResult);
}

enum CryptoResult {
    Ok;
    NotLoaded;
    NoSalt;
    NoKey;
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

    public static function calculate_key(pw:String):CryptoResult {
        if(sodium == null) return CryptoResult.NotLoaded;
        if(salt == null) return CryptoResult.NoSalt;
        Crypto.key = sodium.crypto_pwhash(sodium.crypto_secretbox_KEYBYTES, encoder.encode(pw), salt, sodium.crypto_pwhash_OPSLIMIT_INTERACTIVE, sodium.crypto_pwhash_MEMLIMIT_INTERACTIVE, sodium.crypto_pwhash_ALG_DEFAULT);
        return CryptoResult.Ok;
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