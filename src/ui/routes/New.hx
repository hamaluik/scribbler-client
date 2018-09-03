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

class New implements Mithril {
    @:allow(App) private function new(){}
    
    static var new_title:Ref<String> = new Ref<String>("");

    public function onmatch(args: haxe.DynamicAccess<String>, requestedPath: String) {
        if(App.store.getState().auth.token.match(None)) M.routeSet('/signin');
        new_title.set("");

        return null;
    }

    public function render(vnode: Vnode<New>): Vnodes {
        return [
            m('.is-fullheight', [
                m('.columns.is-gapless', [
                    m(ControlPane, { id: null }),
                    m('.column', [
                        m('header', [
                            m(NoteHeader, { id: null }),
                            m(TagList, { id: null, editable: false })
                        ]),
                        m(EditToolbar, { id: null }),
                        m('section.content')
                    ])
                ])
            ]),
            m(Footer),
            m('.modal.is-active', [
                m('.modal-background[aria-label=cancel]', { onclick: function() { M.routeSet('/view'); } }),
                m('.modal-content', [
                    m('.box.content', [
                        m("form", {
                            onsubmit: function() {
                                if(new_title.value.length == 0) return;
                                var new_id:String = api.Notes.createNote(new_title);
                                M.routeSet('/edit?id=${new_id}');
                            },
                            action: "#"
                        }, [
                            m('p', 'Please enter a title for this note:'),
                            m('.field', [
                                m('label.label', 'Title'),
                                m(TextField, { value: new_title })
                            ]),
                            m('.field.is-grouped.is-grouped-right', [
                                m('.control', [
                                    m('input.button[type=submit].is-primary', { value: 'Create', disabled: new_title.value.length < 1 })
                                ]),
                                m('.control', [
                                    m('a.button.is-text[aria-label=cancel]', { onclick: function() { M.routeSet('/view'); } }, 'Cancel')
                                ])
                            ])
                        ])
                    ])
                ]),
                m('button.modal-close.is-large[aria-label=cancel]', { onclick: function() { M.routeSet('/view'); } })
            ])
        ];
    }
}