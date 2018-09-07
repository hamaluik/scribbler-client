package ui.components;

import bulma.forms.TextField;
import data.actions.NoteActions;
import data.types.Note;
import mithril.M;
import util.Ref;

class TagList implements Mithril {
    static var tags_field:Ref<String> = new Ref<String>("", function(tags:String):Void {
        parse_tags(tags, true);
    });
    static var current_note:Option<Note> = None;

    static function parse_tags(tags:String, quit_if_no_sep:Bool=false):Void {
        if(quit_if_no_sep && tags.indexOf(",") == -1) return;

        tags = StringTools.trim(tags);
        if(tags.length < 1) return;

        if(current_note.match(None)) return;
        var note:Note = switch(current_note) {
            case Some(n): n;
            case _: null;
        }

        var new_tags:Array<String> = tags
            .split(",")
            // tidy the tags
            .map(StringTools.trim)
            .filter(function(t:String):Bool { return t.length > 0; })
            // only add tags if they don't already exist
            .filter(function(t:String):Bool { return note.tags.indexOf(t) == -1; });

        for(tag in new_tags) {
            App.store.dispatch(NoteActions.AddTag(note.id, tag));
        }
        
        tags_field.set("");
    }

    public static function view(node:Vnode<TagList>): Vnodes {
        var editable:Bool = node.attrs.get('editable');
        var id:Null<String> = node.attrs.get('id');
        var note:Option<Note> = App.store.getState().notes.get(id);
        current_note = note;

        return switch(note) {
            case Some(n): {
                if(editable) [
                    m('.field.is-grouped.is-grouped-multiline',
                        [for(tag in n.tags) m('.control', [
                            m('.tags.has-addons', [
                                m('a.tag.is-light', tag),
                                m('a.tag.is-delete[role=button]', { onclick: function() {
                                    App.store.dispatch(NoteActions.RemoveTag(id, tag));
                                }})
                            ])
                        ])]
                    ),
                    m('form', {
                        onsubmit: function() {
                            parse_tags(tags_field);
                        },
                    }, [
                        m(TextField, {
                            placeholder: 'tags, separated by commas',
                            expanded: true,
                            value: tags_field
                        })
                    ])
                ]
                else
                    m('.tags', [for(tag in n.tags) m('span.tag.is-light', tag)]);
            }
            case None: null;
        };
    }
}