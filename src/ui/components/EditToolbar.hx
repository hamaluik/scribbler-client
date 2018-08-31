package ui.components;

import bulma.elements.Icon;
import mithril.M;

class EditToolbar implements Mithril {
    public static function view(node:Vnode<EditToolbar>): Vnodes {
        var id:String = node.attrs.get('id');

        return
        m('section.toolbar', [
            m('a.button.is-text.is-small', { href: '#!/edit?id=${id}' }, [
                m(Icon, {
                    glyph: "edit"
                }),
                m('b', 'Edit')
            ]),
            m('a.button.is-text.is-small', { href: '#!/rename?id=${id}' }, [
                m(Icon, {
                    glyph: "signature"
                }),
                m('b', 'Rename')
            ]),
            m('a.button.is-text.is-small', { href: '#!/pin?id=${id}&return=/view' }, [
                m(Icon, {
                    glyph: "thumbtack"
                }),
                m('b', 'Pin')
            ]),
            m('a.button.is-text.is-small', { href: '#!/delete?id=${id}&return=/view' }, [
                m(Icon, {
                    glyph: "trash"
                }),
                m('b', 'Delete')
            ]),
        ]);
    }
}