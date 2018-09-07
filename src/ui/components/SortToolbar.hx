package ui.components;

import data.actions.SortActions;
import bulma.elements.Icon;
import mithril.M;

class SortToolbar implements Mithril {
    public static function view(node:Vnode<SortToolbar>): Vnodes {
        var titleIcon:Vnodes = switch(App.store.getState().sort.type) {
            case Title(direction): {
                switch(direction) {
                    case Asc: m(Icon, { glyph: "sort-up" });
                    case Desc: m(Icon, { glyph: "sort-down" });
                }
            }
            case _: m(Icon);
        }
        var dateIcon:Vnodes = switch(App.store.getState().sort.type) {
            case Date(direction): {
                switch(direction) {
                    case Asc: m(Icon, { glyph: "sort-up" });
                    case Desc: m(Icon, { glyph: "sort-down" });
                }
            }
            case _: m(Icon);
        }
        
        return
        m('section.toolbar.has-text-centered', [
            m('button.button.is-text.is-small[aria-label="sort by title"]', { onclick: function() {
                switch(App.store.getState().sort.type) {
                    case Title(direction): {
                        switch(direction) {
                            case Asc: App.store.dispatch(SortActions.SortByTitle(Desc));
                            case Desc: App.store.dispatch(SortActions.SortByTitle(Asc));
                        }
                    }

                    case Date(_): {
                        App.store.dispatch(SortActions.SortByTitle(Desc));
                    }
                }
            } }, [
                titleIcon,
                m('b', 'Title')
            ]),
            m('button.button.is-text.is-small[aria-label="sort by date"]', { onclick: function() {
                switch(App.store.getState().sort.type) {
                    case Date(direction): {
                        switch(direction) {
                            case Asc: App.store.dispatch(SortActions.SortByDate(Desc));
                            case Desc: App.store.dispatch(SortActions.SortByDate(Asc));
                        }
                    }

                    case Title(_): {
                        App.store.dispatch(SortActions.SortByDate(Desc));
                    }
                }
            } }, [
                dateIcon,
                m('b', 'Date')
            ]),
        ]);
    }
}