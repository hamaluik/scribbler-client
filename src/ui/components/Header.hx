package ui.components;

import mithril.M;
import bulma.elements.Icon;

class Header implements Mithril {
    public static function view(node:Vnode<Header>): Vnodes {
        return
        m('.columns.is-mobile.is-gapless', [
            m('.column', [
                m('h1.title.is-4', 'Notes'),
            ]),
            m('.column.has-text-right', [
                m('a.button.is-primary.is-small', { href: '#!/new' }, [
                    m(Icon, {
                        glyph: "plus"
                    }),
                    m('b', 'New')
                ]),
            ])
        ]);
    }
}