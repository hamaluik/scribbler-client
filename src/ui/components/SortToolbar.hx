package ui.components;

import bulma.elements.Icon;
import mithril.M;

class SortToolbar implements Mithril {
    public static function view(node:Vnode<SortToolbar>): Vnodes {
        // TODO: sorting mode (ASC / DESC)
        return
        m('section.toolbar.has-text-centered', [
            m('a.button.is-text.is-small', { href: '#!/sort/title' }, [
                m(Icon, {
                    glyph: "caret-up"
                }),
                m('b', 'Title')
            ]),
            m('a.button.is-text.is-small', { href: '#!/sort/date' }, [
                m(Icon, {
                    glyph: "caret-down"
                }),
                m('b', 'Date')
            ]),
        ]);
    }
}