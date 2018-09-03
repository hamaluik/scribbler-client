package api;

import haxe.crypto.Sha256;
import js.Date;
import data.actions.NoteActions;

class Notes {
    /**
       Create a new note using a temporary ID, returning the temporary ID
       @param title The title of the new note
       @return String
    */
    public static function createNote(title:String):String {
        // create temporary id!
        // TODO: maybe just request an ID from the server?
        var createdOn:Date = new Date(Date.now());
        var tempID = "$" + Sha256.encode(title + createdOn.toISOString()).substr(0, 6);
        App.store.dispatch(NoteActions.Create(tempID, title, [], "", createdOn));
        return tempID;
    }
}