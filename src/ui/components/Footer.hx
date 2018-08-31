package ui.components;

import mithril.M;
import bulma.elements.Icon;

class Footer implements Mithril {
    public static function view(node:Vnode<Footer>): Vnodes {
        return
        m('footer', [
            m('span.button.is-text.is-small', 'Last synced Tue Aug 28, 22:08'),
            m('a.button.is-text.is-small', { href: '#!/sync' }, [
                m(Icon, {
                    glyph: "sync-alt"
                }),
                m('b', 'Sync')
            ]),
            m('a.button.is-text.is-small', { href: '#!/signout' }, [
                m(Icon, {
                    glyph: "sign-out-alt"
                }),
                m('b', 'Sign Out')
            ])
        ]);
    }
}