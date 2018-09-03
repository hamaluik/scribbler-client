package ui.components;

import data.types.Note;
import data.actions.NoteActions;
import bulma.elements.Icon;
import mithril.M;

class EditToolbar implements Mithril {
    public static function view(node:Vnode<EditToolbar>): Vnodes {
        var id:Null<String> = node.attrs.get('id');
        var is_editing:Bool = node.attrs.exists('is_editing') && node.attrs.get('is_editing');
        var exists:Bool = App.store.getState().notes.exists(id);
        var save:Void->Void = node.attrs.get('onsave');

        var save_edit_btn:Vnodes = if(is_editing)
            m('button.button.is-text.is-small', { onclick: save }, [
                m(Icon, {
                    glyph: "save"
                }),
                m('b', 'Save')
            ]);
        else
            m('a.button.is-text.is-small', { href: '#!/edit?id=${id}' }, [
                m(Icon, {
                    glyph: "edit"
                }),
                m('b', 'Edit')
            ]);

        return if(exists) {
            var note:Note = App.store.getState().notes.get_unwrapped(id);
            m('section.toolbar', [
                save_edit_btn,
                m('a.button.is-text.is-small', { href: '#!/rename?id=${id}' }, [
                    m(Icon, {
                        glyph: "signature"
                    }),
                    m('b', 'Rename')
                ]),
                m('button.button.is-text.is-small', { onclick: function() {
                    App.store.dispatch(note.pinned ? NoteActions.UnPin(id) : NoteActions.Pin(id));
                } }, [
                    m(Icon, {
                        glyph: "star",
                        style: note.pinned ? 'far' : 'fas'
                    }),
                    m('b', note.pinned ? 'Unpin' : 'Pin')
                ]),
                m('a.button.is-text.is-small', { href: '#!/delete?id=${id}' }, [
                    m(Icon, {
                        glyph: "trash"
                    }),
                    m('b', 'Delete')
                ]),
            ]);
        }
        else null;
    }
}