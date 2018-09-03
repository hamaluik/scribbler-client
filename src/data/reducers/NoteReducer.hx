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
                    pinned: false
                };
                var newNote = {};
                Reflect.setField(newNote, id, note);
                js.Object.assign(blank, state, newNote);
            }

            case Rename(id, newTitle): {
                // reject if we don't already exist
                if(!state.exists(id)) {
                    App.console.warn('tried to rename note with id ${id} but that note doesn\'t exist!');
                    return state;
                }
                var note:Note = state.get_unwrapped(id);
                note.title = newTitle;
                var newNote = {};
                Reflect.setField(newNote, id, note);
                js.Object.assign(blank, state, newNote);
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
                // reject if we don't already exist
                if(!state.exists(id)) {
                    App.console.warn('tried to edit note with id ${id} but that note doesn\'t exist!');
                    return state;
                }
                var note:Note = state.get_unwrapped(id);
                note.tags.push(newTag);
                var newNote = {};
                Reflect.setField(newNote, id, note);
                js.Object.assign(blank, state, newNote);
            }

            case RemoveTag(id, oldTag): {
                // reject if we don't already exist
                if(!state.exists(id)) {
                    App.console.warn('tried to edit note with id ${id} but that note doesn\'t exist!');
                    return state;
                }
                var note:Note = state.get_unwrapped(id);
                note.tags.remove(oldTag);
                var newNote = {};
                Reflect.setField(newNote, id, note);
                js.Object.assign(blank, state, newNote);
            }

            case Delete(id): {
                // reject if we don't already exist
                if(!state.exists(id)) {
                    App.console.warn('tried to edit note with id ${id} but that note doesn\'t exist!');
                    return state;
                }

                // delete the field!
                Reflect.deleteField(state, id);
                js.Object.assign(blank, state);
            }

            case Pin(id): {
                // reject if we don't already exist
                if(!state.exists(id)) {
                    App.console.warn('tried to edit note with id ${id} but that note doesn\'t exist!');
                    return state;
                }
                var note:Note = state.get_unwrapped(id);
                note.pinned = true;
                var newNote = {};
                Reflect.setField(newNote, id, note);
                js.Object.assign(blank, state, newNote);
            }

            case UnPin(id): {
                // reject if we don't already exist
                if(!state.exists(id)) {
                    App.console.warn('tried to edit note with id ${id} but that note doesn\'t exist!');
                    return state;
                }
                var note:Note = state.get_unwrapped(id);
                note.pinned = false;
                var newNote = {};
                Reflect.setField(newNote, id, note);
                js.Object.assign(blank, state, newNote);
            }
        };
    }

    public function new() {}
}