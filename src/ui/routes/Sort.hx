package ui.routes;

import mithril.M;

class Sort implements Mithril {
    @:allow(App) private function new(){}

    public function onmatch(args: haxe.DynamicAccess<String>, requestedPath: String) {
        if(App.store.getState().auth.token.match(None)) M.routeSet('/signin');
        else {
            // TODO: fire action
            App.console.debug('Sorting by method', args.get('method'));
            M.routeSet('/view');
        }
        return null;
    }

    public function render(vnode: Vnode<Sort>): Vnodes {
        return null;
    }
}