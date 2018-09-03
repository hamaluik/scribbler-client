package ui.components;

import mithril.M;
import bulma.elements.Icon;

class Footer implements Mithril {
    public static function view(node:Vnode<Footer>): Vnodes {
        return
        m('footer', [
            m('span.button.is-text.is-small', 'Last synced Tue Aug 28, 22:08'),
            m('button.button.is-text.is-small', { onclick: function() {
                App.console.debug('TODO: sync');
            } }, [
                m(Icon, {
                    glyph: "sync-alt"
                }),
                m('b', 'Sync')
            ]),
            m('button.button.is-text.is-small', { onclick: function() {
                App.console.debug('attempting sign out...');
                api.Auth.signOut();
                M.routeSet('/signin');
            } }, [
                m(Icon, {
                    glyph: "sign-out-alt"
                }),
                m('b', 'Sign Out')
            ])
        ]);
    }
}