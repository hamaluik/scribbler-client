package ui.routes;

import bulma.forms.TextField;
import data.actions.NoteActions;
import util.Ref;
import ui.components.Footer;
import ui.components.EditToolbar;
import ui.components.NoteHeader;
import ui.components.TagList;
import ui.components.ControlPane;
import data.types.Note;
import mithril.M;

class Rename implements Mithril {
    @:allow(App) private function new(){}
    
    static var new_title:Ref<String> = new Ref<String>("");

    public function onmatch(args: haxe.DynamicAccess<String>, requestedPath: String) {
        if(App.store.getState().auth.token.match(None)) M.routeSet('/signin');

        var id:Null<String> = args.get('id');
        var note:Option<Note> = App.store.getState().notes.get(id);
        new_title.set(switch(note) {
            case Some(n): n.title;
            case None: "";
        });

        return null;
    }

    public function render(vnode: Vnode<Rename>): Vnodes {
        var id:Null<String> = M.routeAttrs(vnode).get('id');
        var note:Option<Note> = id == null ? None : App.store.getState().notes.get(id);

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
                m('.modal-background[aria-label=cancel]', { onclick: function() { M.routeSet('/view?id=${id}'); } }),
                m('.modal-content', [
                    m('.box.content', [
                        m("form", {
                            onsubmit: function() {
                                App.store.dispatch(NoteActions.Rename(id, new_title));
                                M.routeSet('/view?id=${id}');
                            },
                            action: "#"
                        }, [
                            m('p', 'Please enter the new name for this note:'),
                            m('.field', [
                                m('label.label', 'New Title'),
                                m(TextField, { value: new_title })
                            ]),
                            m('.field.is-grouped.is-grouped-right', [
                                m('.control', [
                                    m('input.button[type=submit].is-primary', { value: 'Save' })
                                ]),
                                m('.control', [
                                    m('a.button.is-text[aria-label=cancel]', { onclick: function() { M.routeSet('/view?id=${id}'); } }, 'Cancel')
                                ])
                            ])
                        ])
                    ])
                ]),
                m('button.modal-close.is-large[aria-label=cancel]', { onclick: function() { M.routeSet('/view?id=${id}'); } })
            ])
        ];
    }
}