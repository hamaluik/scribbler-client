package ui.components;

import mithril.M;

class TagList implements Mithril {
    public static function view(node:Vnode<TagList>): Vnodes {
        var editable:Bool = node.attrs.get('editable');
        var id:String = node.attrs.get('id');
        // TODO: get tags from the store
        var tags:Array<String> = ['dummy', 'tags'];

        return if(editable)
            m('.field.is-grouped.is-grouped-multiline',
                [for(tag in tags) m('.control', [
                    m('.tags.has-addons', [
                        m('a.tag.is-light', tag),
                        m('a.tag.is-delete') // TODO: delete tag action
                    ])
                ])]
            );
        else
            m('.tags', [for(tag in tags) m('span.tag.is-light', tag)]);
    }
}