package ui.components;

import bulma.elements.Icon;
import mithril.M;

class SortToolbar implements Mithril {
    public static function view(node:Vnode<SortToolbar>): Vnodes {
        // TODO: sorting mode (ASC / DESC)
        return
        m('section.toolbar.has-text-centered', [
            m('button.button.is-text.is-small[aria-label="sort by title"]', { onclick: function() {} }, [
                m(Icon, {
                    glyph: "caret-up"
                }),
                m('b', 'Title')
            ]),
            m('button.button.is-text.is-small[aria-label="sort by date"]', { onclick: function() {} }, [
                m(Icon, {
                    glyph: "caret-down"
                }),
                m('b', 'Date')
            ]),
        ]);
    }
}