package ui.components;

import mithril.M;

class NoteInList implements Mithril {
    public static function view(node:Vnode<NoteInList>): Vnodes {
        var title:String = node.attrs.get('title');
        var date:String = node.attrs.get('date');
        var tags:Array<String> = node.attrs.get('tags');
        var tagDisplay:Vnodes = [for(tag in tags) m('span.tag.is-light', tag)];
        var selected:Bool = node.attrs.get('selected');

        return
        m('a.content' + (selected ? '.selected' : ''), [
            m('h1.title.is-4', title),
            m('h2.subtitle.is-6', date),
            m('.tags', tagDisplay)
        ]);
    }
}