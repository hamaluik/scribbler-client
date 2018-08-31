package data.actions;

import js.Date;

enum NoteActions {
    Create(id:String, title:String, tags:Array<String>, contents:String, created:Date);
    Rename(id:String, newTitle:String);
    Edit(id:String, newContents:String, modified:Date);
    AddTag(id:String, newTag:String);
    RemoveTag(id:String, oldTag:String);
    Delete(id:String);
}