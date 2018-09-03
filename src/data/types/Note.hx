package data.types;

import js.Date;

typedef Note = {
    var id:String;
    var title:String;
    var lastModified:Date;
    var tags:Array<String>;
    var note:String;
    var pinned:Bool;
};