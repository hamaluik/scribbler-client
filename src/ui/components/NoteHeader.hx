package ui.components;

import data.types.Note;
import mithril.M;

class NoteHeader implements Mithril {
    public static function view(node:Vnode<NoteHeader>): Vnodes {
        var id:Null<String> = node.attrs.get('id');
        var note:Option<Note> = App.store.getState().notes.get(id);
        var editable:Bool = node.attrs.get('editable');

        return switch(note) {
            case Some(n): [
                m('header', [
                    m('h1.title', n.title), // TODO: make editable
                    m('h2.subtitle', [
                        "Last modified ",
                        m('time', { datetime: n.lastModified.toISOString() }, n.lastModified.toString())
                    ]),
                    m(TagList, { id: id, editable: editable })
                ])
            ];
            case None: null;
        };
    }
}