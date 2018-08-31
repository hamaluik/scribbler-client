package data.types;

import util.Base64String;

typedef ServerNote = {
    @:optional var id:String,
    var version:Int;
    var content:Base64String;
    var nonce:Base64String;
};