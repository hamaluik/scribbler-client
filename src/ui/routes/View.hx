package ui.routes;

import data.types.Note;
import mithril.M;
import ui.components.ControlPane;
import ui.components.EditToolbar;
import ui.components.Footer;
import ui.components.NoteHeader;

class View implements Mithril {
    @:allow(App) private function new(){}

    public function onmatch(args: haxe.DynamicAccess<String>, requestedPath: String) {
        if(App.store.getState().auth.token.match(None)) M.routeSet('/signin');
        return null;
    }

    public function render(vnode: Vnode<View>): Vnodes {
        var id:Null<String> = M.routeAttrs(vnode).get('id');
        var note:Option<Note> = App.store.getState().notes.get(id);
        var rendered:Vnodes = switch(note) {
            case Some(n): M.trust(App.markdown.render(n.note));
            case None: null;
        };

        return [
            m('.is-fullheight', [
                m('.columns.is-gapless', [
                    m(ControlPane),
                    m('.column', [
                        m(NoteHeader, { id: id, editable: false }),
                        m(EditToolbar, { id: id, is_editing: false }),
                        m('section.content', rendered)
                    ])
                ])
            ]),
            m(Footer)
        ];
    }
}