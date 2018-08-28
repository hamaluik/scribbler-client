import sodium.Sodium;
import js.html.Uint8Array;
import js.html.TextEncoder;
import js.html.TextDecoder;
import js.Promise;
import js.Browser;

enum CryptoError {
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

    public static function generate_salt():Result<Uint8Array, CryptoError> {
        if(sodium == null) return Err(NotLoaded);
        Crypto.salt = sodium.randombytes_buf(sodium.crypto_pwhash_SALTBYTES);
        return Ok(Crypto.salt);
    }

    /**
       Derive an encryption key and server key from a supplied password, storing the encryption key for later use
       @param pw The password to derive from
       @return Result<Uint8Array, CryptoError>
    */
    public static function calculate_key(pw:String):Result<Uint8Array, CryptoError> {
        if(sodium == null) return Err(NotLoaded);
        if(salt == null) return Err(NoSalt);
        var full_key:Uint8Array = sodium.crypto_pwhash(sodium.crypto_secretbox_KEYBYTES * 2, encoder.encode(pw), salt, sodium.crypto_pwhash_OPSLIMIT_INTERACTIVE, sodium.crypto_pwhash_MEMLIMIT_INTERACTIVE, sodium.crypto_pwhash_ALG_DEFAULT);
        Crypto.key = full_key.subarray(0, sodium.crypto_secretbox_KEYBYTES);
        var server_key:Uint8Array = full_key.subarray(sodium.crypto_secretbox_KEYBYTES);
        return Ok(server_key);
    }

    public static function encrypt(message:String):Result<{cipher_text:Uint8Array, nonce:Uint8Array}, CryptoError> {
        if(sodium == null) return Err(NotLoaded);
        if(key == null) return Err(NoKey);
        var nonce:Uint8Array = sodium.randombytes_buf(sodium.crypto_secretbox_NONCEBYTES);
        var cipher_text:Uint8Array = sodium.crypto_secretbox_easy(encoder.encode(message), nonce, key);
        return Ok({cipher_text: cipher_text, nonce: nonce});
    }

    public static function decrypt(cipher_text:Uint8Array, nonce:Uint8Array):Result<String, CryptoError> {
        if(sodium == null) return Err(NotLoaded);
        if(key == null) return Err(NoKey);
        return Ok(decoder.decode(sodium.crypto_secretbox_open_easy(cipher_text, nonce, key)));
    }
}