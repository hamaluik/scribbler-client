package ui.routes;

import mithril.M;

class New implements Mithril {
    @:allow(App) private function new(){}

    public function onmatch(args: haxe.DynamicAccess<String>, requestedPath: String) {
        if(App.store.getState().auth.token.match(None)) M.routeSet('/signin');
        else {
            // TODO: fire action
            App.console.debug('Creating new note...');
            M.routeSet('/edit');
        }
        return null;
    }

    public function render(vnode: Vnode<New>): Vnodes {
        return null;
    }
}