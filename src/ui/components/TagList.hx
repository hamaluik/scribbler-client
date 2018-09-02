package ui.components;

import data.types.Note;
import mithril.M;

class TagList implements Mithril {
    public static function view(node:Vnode<TagList>): Vnodes {
        var editable:Bool = node.attrs.get('editable');
        var id:Null<String> = node.attrs.get('id');
        var note:Option<Note> = App.store.getState().notes.get(id);

        return switch(note) {
            case Some(n): {
                if(editable)
                    m('.field.is-grouped.is-grouped-multiline',
                        [for(tag in n.tags) m('.control', [
                            m('.tags.has-addons', [
                                m('a.tag.is-light', tag),
                                m('a.tag.is-delete') // TODO: delete tag action
                            ])
                        ])]
                    );
                else
                    m('.tags', [for(tag in n.tags) m('span.tag.is-light', tag)]);
            }
            case None: null;
        };
    }
}