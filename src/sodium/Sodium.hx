package sodium;

import js.Browser;
import js.html.Uint8Array;

extern class Sodium {
    public var crypto_pwhash_OPSLIMIT_INTERACTIVE(default, null):Int;
    public var crypto_pwhash_MEMLIMIT_INTERACTIVE(default, null):Int;
    public var crypto_secretbox_NONCEBYTES(default, null):Int;
    public var crypto_pwhash_ALG_DEFAULT(default, null):Int;
    public var crypto_secretbox_KEYBYTES(default, null):Int;
    public var crypto_pwhash_SALTBYTES(default, null):Int;

    public function crypto_pwhash(keyLength:Int, password:Uint8Array, salt:Uint8Array, opsLimit:Int, memLimit:Int, algorithm:Int):Uint8Array;
    public function randombytes_buf(length:Int):Uint8Array;
    public function crypto_secretbox_easy(message:Uint8Array, nonce:Uint8Array, key:Uint8Array):Uint8Array;
    public function crypto_secretbox_open_easy(ciphertext:Uint8Array, none:Uint8Array, key:Uint8Array):Uint8Array;
}
