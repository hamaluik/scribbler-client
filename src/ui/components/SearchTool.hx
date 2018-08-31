package ui.components;

import mithril.M;
import bulma.elements.Icon;

class SearchTool implements Mithril {
    public static function view(node:Vnode<SearchTool>): Vnodes {
        return
        m('header', [
            m('form', {
                onsubmit: function() {},
                action: '#'
            }, [
                m('.field.has-addons', [
                    m('.control.is-expanded', [
                        m('input.input.is-small', {
                            type: 'text',
                            placeholder: 'title, tags, etc'
                        })
                    ]),
                    m('.control', [
                        m('button.button.is-dark.is-small', { type: 'submit' }, [
                            m(Icon, {
                                glyph: "search"
                            }),
                            m('span', 'Search')
                        ])
                    ])
                ])
            ])
        ]);
    }
}