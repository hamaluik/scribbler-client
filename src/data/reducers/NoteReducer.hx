package data.reducers;

import data.actions.NoteActions;
import data.state.IDMapState;
import data.types.Note;

class NoteReducer implements redux.IReducer<NoteActions, IDMapState<Note>> {
    public var initState:IDMapState<Note> = {};

    public function reduce(state: IDMapState<Note>, action: NoteActions): IDMapState<Note> {
        var blank:IDMapState<Note> = {};
        return switch(action) {
            case Create(id, title, tags, contents, created): {
                var note:Note = {
                    id: id,
                    title: title,
                    lastModified: created,
                    tags: tags,
                    note: contents,
                };
                var newNote = {};
                Reflect.setField(newNote, id, note);
                js.Object.assign(blank, state, newNote);
            }

            case Rename(id, newTitle): {
                // TODO: implement!
                App.console.warn("Rename isn't implemented yet!");
                js.Object.assign(blank, state);
            }

            case Edit(id, newContents, modified): {
                // reject if we don't already exist
                if(!state.exists(id)) {
                    App.console.warn('tried to edit note with id ${id} but that note doesn\'t exist!');
                    return state;
                }
                var note:Note = state.get_unwrapped(id);
                note.note = newContents;
                note.lastModified = modified;
                var newNote = {};
                Reflect.setField(newNote, id, note);
                js.Object.assign(blank, state, newNote);
            }

            case AddTag(id, newTag): {
                // TODO: implement!
                App.console.warn("AddTag isn't implemented yet!");
                js.Object.assign(blank, state);
            }

            case RemoveTag(id, oldTag): {
                // TODO: implement!
                App.console.warn("RemoveTag isn't implemented yet!");
                js.Object.assign(blank, state);
            }

            case Delete(id): {
                // TODO: implement!
                App.console.warn("Delete isn't implemented yet!");
                js.Object.assign(blank, state);
            }
        };
    }

    public function new() {}
}