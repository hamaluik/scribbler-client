package ui.components;

import data.actions.SortFilterActions;
import bulma.forms.TextField;
import mithril.M;
import bulma.elements.Icon;
import util.Ref;

class SearchTool implements Mithril {
    static var search_string:Ref<String> = new Ref<String>("", function(query:String):Void {
        App.store.dispatch(SortFilterActions.Filter(query));
    });

    public static function view(node:Vnode<SearchTool>): Vnodes {
        return
        m('header', [
            m('form', {
                onsubmit: function() {
                    App.store.dispatch(SortFilterActions.Filter(search_string));
                },
                action: '#'
            }, [
                m('.field.has-addons', [
                    m(TextField, {
                        placeholder: 'title, tags, etc',
                        expanded: true,
                        size: 'small',
                        value: search_string
                    }),
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