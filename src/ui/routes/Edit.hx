package ui.routes;

import ui.components.Footer;
import ui.components.EditToolbar;
import ui.components.NoteHeader;
import ui.components.TagList;
import ui.components.ControlPane;
import data.types.Note;
import mithril.M;

class Edit implements Mithril {
    @:allow(App) private function new(){}

    public function onmatch(args: haxe.DynamicAccess<String>, requestedPath: String) {
        if(App.store.getState().auth.token.match(None)) M.routeSet('/signin');
        return null;
    }

    public function render(vnode: Vnode<Edit>): Vnodes {
        var id:Null<String> = M.routeAttrs(vnode).get('id');
        var note:Option<Note> = id == null ? None : App.store.getState().notes.get(id);

        var note_contents:String = switch(note) {
            case Some(n): n.note;
            case None: "";
        };

        return [
            m('.is-fullheight', [
                m('.columns.is-gapless', [
                    m(ControlPane, { id: id }),
                    m('.column.editor', [
                        m('header', [
                            m(NoteHeader, { id: id }),
                            m(TagList, { id: id, editable: true })
                        ]),
                        m(EditToolbar, { id: id, is_editing: true }),
                        m('section.editor', [
                            m('textarea', [
                                note_contents
                            ])
                        ])
                    ])
                ])
            ]),
            m(Footer)
        ];
    }
}