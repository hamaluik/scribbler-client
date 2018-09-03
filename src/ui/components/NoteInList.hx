package ui.components;

import bulma.elements.Icon;
import data.types.Note;
import mithril.M;

class NoteInList implements Mithril {
    public static function view(node:Vnode<NoteInList>): Vnodes {
        var id:String = node.attrs.get('id');
        var note:Note = App.store.getState().notes.get_unwrapped(id);

        var tagDisplay:Vnodes = [for(tag in note.tags) m('span.tag.is-light', tag)];
        var selected:Bool = node.attrs.get('selected');

        return
        m('a.content' + (selected ? '.selected' : ''), {
            href: '#!/view?id=${id}'
        }, [
            m('h1.title.is-4', note.title),
            m('h2.subtitle.is-6', note.lastModified.toString()),
            note.pinned ? m(Icon, { glyph: 'star' }) : null,
            m('.tags', tagDisplay),
        ]);
    }
}