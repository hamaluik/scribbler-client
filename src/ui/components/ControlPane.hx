package ui.components;

import mithril.M;

class ControlPane implements Mithril {
    public static function view(node:Vnode<ControlPane>): Vnodes {
        return
        m('.column.is-one-quarter.note-list', [
            m(Header),
            m(SearchTool),
            m(SortToolbar),
            m(NoteList, { id: node.attrs.get('id') }),
        ]);
    }
}