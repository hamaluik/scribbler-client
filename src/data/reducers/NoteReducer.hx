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
                var newNote:Note = {
                    id: created.toISOString(),
                    title: title,
                    lastModified: created,
                    tags: tags,
                    note: contents,
                };
                var newProject = {};
                Reflect.setField(newProject, id, newNote);
                js.Object.assign(blank, state, newProject);
            }

            case Rename(id, newTitle): {
                // TODO: implement!
                js.Object.assign(blank, state);
            }

            case Edit(id, newContents, modified): {
                // TODO: implement!
                js.Object.assign(blank, state);
            }

            case AddTag(id, newTag): {
                // TODO: implement!
                js.Object.assign(blank, state);
            }

            case RemoveTag(id, oldTag): {
                // TODO: implement!
                js.Object.assign(blank, state);
            }

            case Delete(id): {
                // TODO: implement!
                js.Object.assign(blank, state);
            }
        };
    }

    public function new() {}
}