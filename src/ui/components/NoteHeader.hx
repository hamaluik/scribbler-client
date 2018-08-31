package ui.components;

import js.Date;
import mithril.M;

class NoteHeader implements Mithril {
    public static function view(node:Vnode<NoteHeader>): Vnodes {
        var id:String = node.attrs.get('id');
        // TODO: get data from the store
        var title:String = "Lorem Ipsum";
        var date:Date = new Date(Date.now());
        var dateDisplay:String = date.toString();
        var dateStamp:String = date.toISOString();

        return [
            m('h1.title', title),
            m('h2.subtitle', [
                "Last modified ",
                m('time', { datetime: dateStamp }, dateDisplay)
            ]),
        ];
    }
}