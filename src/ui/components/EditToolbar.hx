package ui.components;

import bulma.elements.Icon;
import mithril.M;

class EditToolbar implements Mithril {
    public static function view(node:Vnode<EditToolbar>): Vnodes {
        var id:Null<String> = node.attrs.get('id');
        var is_editing:Bool = node.attrs.exists('is_editing') && node.attrs.get('is_editing');
        var exists:Bool = App.store.getState().notes.exists(id);

        var save_edit_btn:Vnodes = if(is_editing)
            m('button.button.is-text.is-small', { onclick: function() {
                App.console.debug('TODO: save the note!');
                M.routeSet('#!/view?id=${id}');
            } }, [
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

        return if(exists)
            m('section.toolbar', [
                save_edit_btn,
                m('a.button.is-text.is-small', { href: '#!/rename?id=${id}' }, [
                    m(Icon, {
                        glyph: "signature"
                    }),
                    m('b', 'Rename')
                ]),
                m('button.button.is-text.is-small', { onclick: function() {
                    App.console.debug('TODO: pin it!');
                } }, [
                    m(Icon, {
                        glyph: "thumbtack"
                    }),
                    m('b', 'Pin')
                ]),
                m('a.button.is-text.is-small', { href: '#!/delete?id=${id}' }, [
                    m(Icon, {
                        glyph: "trash"
                    }),
                    m('b', 'Delete')
                ]),
            ]);
        else null;
    }
}