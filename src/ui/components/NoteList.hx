package ui.components;

import data.types.Note;
import mithril.M;

class NoteList implements Mithril {
    public static function view(node:Vnode<NoteList>): Vnodes {
        var id:Null<String> = node.attrs.get('id');
        var notes:Array<Note> = App.store.getState().notes.getAll();
        
        if(!App.store.getState().sortfilter.filter.match(None)) {
            var query:String = switch(App.store.getState().sortfilter.filter) {
                case Some(q): q;
                case None: "";
            };
            notes = notes.filter(function(note:Note):Bool {
                // search in title
                if(note.title.indexOf(query) != -1) return true;
                // search in tags
                for(tag in note.tags) {
                    if(tag.indexOf(query) != -1) return true;
                }
                return false;
            });
        }

        notes.sort(function(a:Note, b:Note):Int {
            return switch([a.pinned, b.pinned]) {
                case [true, false]: -1;
                case [false, true]: 1;
                case [_, _]: {
                    switch(App.store.getState().sortfilter.sort) {
                        case Date(direction): {
                            switch(direction) {
                                case Desc: Std.int(b.lastModified.getTime() - a.lastModified.getTime());
                                case Asc: Std.int(a.lastModified.getTime() - b.lastModified.getTime());
                            }
                        }
                        case Title(direction): {
                            switch(direction) {
                                case Desc: b.title.toLowerCase() < a.title.toLowerCase() ? 1 : -1;
                                case Asc: a.title.toLowerCase() < b.title.toLowerCase() ? 1 : -1;
                            }
                        }
                    }
                }
            }
        });

        var no_notes_notice:Vnodes = if(notes.length == 0) {
            m('p.content.has-text-centered', App.store.getState().sortfilter.filter.match(None) ? 'No notes yet!' : 'Nothing was found!');
        }
        else null;

        return 
        m('section.list', [for(note in notes)
            m(NoteInList, {
                id: note.id,
                selected: id != null && note.id == id
            })
        ], no_notes_notice);
    }
}
