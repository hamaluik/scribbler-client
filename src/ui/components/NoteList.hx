package ui.components;

import data.types.Note;
import mithril.M;

class NoteList implements Mithril {
    public static function view(node:Vnode<NoteList>): Vnodes {
        var id:Null<String> = node.attrs.get('id');
        var notes:Array<Note> = App.store.getState().notes.getAll();
        // TODO: apply filter
        notes.sort(function(a:Note, b:Note):Int {
            // TODO: use the sorting buttons
            return Std.int(b.lastModified.getTime() - a.lastModified.getTime());
        });

        var no_notes_notice:Vnodes = if(notes.length == 0) {
            m('p.content.has-text-centered', 'No notes yet!');
        }
        else null;

        return 
        m('section.list', [for(note in notes)
            m(NoteInList, {
                id: note.id,
                title: note.title,
                date: note.lastModified.toString(),
                tags: note.tags,
                selected: id != null && note.id == id
            })
        ], no_notes_notice);
    }
}
