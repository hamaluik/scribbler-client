package data.types;

import js.Date;

typedef Note = {
    var title:String;
    var lastModified:Date;
    var tags:Array<String>;
    var note:String;
};