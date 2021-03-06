package ui.routes;

import mithril.M;

class Default implements Mithril {
    @:allow(App) private function new(){}

    public function onmatch(args: haxe.DynamicAccess<String>, requestedPath: String) {
        if(App.store.getState().auth.token.match(None)) M.routeSet('/signin');
        else M.routeSet('/view');
        return null;
    }

    public function render(vnode: Vnode<Default>): Vnodes {
        return null;
    }
}