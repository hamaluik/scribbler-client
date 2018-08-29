package ui.routes;

import mithril.M;
import ui.components.NoteInList;
import bulma.elements.Icon;

class Default implements Mithril {
    @:allow(App) private function new(){}

    public function onmatch(args: haxe.DynamicAccess<String>, requestedPath: String) {
        // TODO: re-enable!
        //if(App.store.getState().auth.token.match(None)) M.routeSet('/signin');
        return null;
    }

    public function render(vnode: Vnode<Default>): Vnodes {
        var rendered_html:String = App.markdown.render("# A Header
Et fugiat tempor quis laborum ad id ad exercitation aliqua nostrud duis. Pariatur dolore sint sit esse qui veniam aute fugiat. Aute fugiat enim velit eiusmod elit. Dolor ea enim reprehenderit et. Excepteur sunt tempor ea sit eu laboris quis cillum ad pariatur qui. Reprehenderit dolor voluptate enim irure enim qui.");

        return [
            m('.is-fullheight', [
                m('.columns.is-gapless', [
                    m('.column.is-one-quarter.note-list', [
                        m('.columns.is-mobile.is-gapless', [
                            m('.column', [
                                m('h1.title.is-4', 'Notes'),
                            ]),
                            m('.column.has-text-right', [
                                m('a.button.is-primary.is-small', { href: '#!/' }, [
                                    m(Icon, {
                                        glyph: "plus"
                                    }),
                                    m('b', 'New')
                                ]),
                            ])
                        ]),
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
                        ]),
                        m('section.toolbar.has-text-centered', [
                            m('a.button.is-text.is-small', { href: '#!/' }, [
                                m(Icon, {
                                    glyph: "caret-up"
                                }),
                                m('b', 'Title')
                            ]),
                            m('a.button.is-text.is-small', { href: '#!/' }, [
                                m(Icon, {
                                    glyph: "caret-down"
                                }),
                                m('b', 'Date')
                            ]),
                        ]),
                        m('section.list', [
                            m(NoteInList, {
                                title: "Mom's Chilli",
                                date: "Tue Aug 28, 22:47",
                                tags: ["Recipe"],
                                selected: true
                            }),
                            m(NoteInList, {
                                title: "Beef Stew",
                                date: "Tue Aug 28, 22:52",
                                tags: ["Recipe", "Instant Pot"]
                            }),
                        ])
                    ]),
                    m('.column', [
                        m('header', [
                            m('h1.title', "Lorem Ipsum"),
                            m('h2.subtitle', "Last modified Tue Aug 28, 22:08"),
                            m('.field.is-grouped.is-grouped-multiline', [
                                m('.control', [
                                    m('.tags.has-addons', [
                                        m('a.tag.is-light', "Recipe"),
                                        m('a.tag.is-delete')
                                    ])
                                ]),
                                m('.control', [
                                    m('.tags.has-addons', [
                                        m('a.tag.is-light', "Instant Pot"),
                                        m('a.tag.is-delete')
                                    ])
                                ])
                            ])
                        ]),
                        m('section.toolbar', [
                            m('a.button.is-text.is-small', { href: '#!/edit' }, [
                                m(Icon, {
                                    glyph: "edit"
                                }),
                                m('b', 'Edit')
                            ]),
                            m('a.button.is-text.is-small', { href: '#!/edit' }, [
                                m(Icon, {
                                    glyph: "thumbtack"
                                }),
                                m('b', 'Pin')
                            ]),
                            m('a.button.is-text.is-small', { href: '#!/edit' }, [
                                m(Icon, {
                                    glyph: "trash"
                                }),
                                m('b', 'Delete')
                            ]),
                        ]),
                        m('section.content', M.trust(rendered_html))
                    ])
                ])
            ]),
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
            ])
        ];
    }
}