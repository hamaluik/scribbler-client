package ui.routes;

import util.Ref;
import ui.components.MarkdownEditor;
import data.actions.NoteActions;
import ui.components.Footer;
import ui.components.EditToolbar;
import ui.components.NoteHeader;
import ui.components.ControlPane;
import data.types.Note;
import mithril.M;
import js.Date;

class Edit implements Mithril {
    @:allow(App) private function new(){}
    
    static var note_contents:Ref<String> = new Ref<String>("");

    public function onmatch(args: haxe.DynamicAccess<String>, requestedPath: String) {
        if(App.store.getState().auth.token.match(None)) M.routeSet('/signin');

        var id:Null<String> = args.get('id');
        var note:Option<Note> = App.store.getState().notes.get(id);
        note_contents.set(switch(note) {
            case Some(n): n.note;
            case None: "";
        });

        return null;
    }

    public function render(node: Vnode<Edit>): Vnodes {
        var id:Null<String> = M.routeAttrs(node).get('id');

        return [
            m('.is-fullheight', [
                m('.columns.is-gapless', [
                    m(ControlPane, { id: id }),
                    m('.column.editor', [
                        m(NoteHeader, { id: id, editable: true }),
                        m(EditToolbar, { id: id, is_editing: true, onsave: function() {
                            App.store.dispatch(NoteActions.Edit(id, note_contents.value, new Date(Date.now())));
                            M.routeSet('/view?id=${id}');
                        } }),
                        m('section.editor', [
                            m(MarkdownEditor, {
                                value: note_contents,
                                onblur: function() {
                                    App.store.dispatch(NoteActions.Edit(id, note_contents.value, new Date(Date.now())));
                                }
                            })
                        ])
                    ])
                ])
            ]),
            m(Footer)
        ];
    }
}