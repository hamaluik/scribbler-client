package ui.routes;

import ui.components.Footer;
import ui.components.EditToolbar;
import ui.components.NoteHeader;
import ui.components.TagList;
import ui.components.ControlPane;
import data.types.Note;
import mithril.M;

class Delete implements Mithril {
    @:allow(App) private function new(){}

    public function onmatch(args: haxe.DynamicAccess<String>, requestedPath: String) {
        if(App.store.getState().auth.token.match(None)) M.routeSet('/signin');
        return null;
    }

    public function render(vnode: Vnode<Delete>): Vnodes {
        var id:Null<String> = M.routeAttrs(vnode).get('id');
        var note:Option<Note> = App.store.getState().notes.get(id);

        var rendered_html:String = switch(note) {
            case Some(n): App.markdown.render(n.note);
            case None: "";
        };

        return [
            m('.is-fullheight', [
                m('.columns.is-gapless', [
                    m(ControlPane, { id: id }),
                    m('.column', [
                        m('header', [
                            m(NoteHeader, { id: id }),
                            m(TagList, { id: id, editable: false })
                        ]),
                        m(EditToolbar, { id: id }),
                        m('section.content', M.trust(rendered_html))
                    ])
                ])
            ]),
            m(Footer),
            m('.modal.is-active', [
                m('.modal-background[aria-label=close]', { onclick: function() { M.routeSet('#!/view?id=${id}'); } }),
                m('.modal-content', [
                    m('.box.content', [
                        m('p', 'Are you sure you want to delete this note? This cannot be undone!')
                    ])
                ]),
                m('button.modal-close.is-large[aria-label=close]', { onclick: function() { M.routeSet('#!/view?id=${id}'); } })
            ])
        ];
    }
}