package util;

import js.html.Uint8Array;
import haxe.crypto.Base64;
import haxe.io.Bytes;

abstract Base64String(String) from String {
    @:to public function to_bytes():Uint8Array {
        var bytes:Bytes = Base64.decode(this);
        return new Uint8Array(bytes.getData());
    }

    @:from public static function from_bytes(bytes:Uint8Array):Base64String {
        var b:Bytes = Bytes.ofData(bytes.buffer);
        return Base64.encode(b);
    }
}