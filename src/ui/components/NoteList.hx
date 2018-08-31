package ui.components;

import mithril.M;

class NoteList implements Mithril {
    public static function view(node:Vnode<NoteList>): Vnodes {
        var id:String = node.attrs.get('id');

        // TODO: fetch notes from store
        // TODO: apply filter
        return 
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
        ]);
    }
}
