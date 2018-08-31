package ui.routes;

import mithril.M;

class Pin implements Mithril {
    @:allow(App) private function new(){}

    public function onmatch(args: haxe.DynamicAccess<String>, requestedPath: String) {
        if(App.store.getState().auth.token.match(None)) M.routeSet('/signin');
        else {
            // TODO: fire action
            App.console.debug('Pinning item', args.get('id'));
            var ret:String = args.exists('return') ? args.get('return') : '/view';
            App.console.debug('Coming from', ret);
            M.routeSet(ret);
        }
        return null;
    }

    public function render(vnode: Vnode<Pin>): Vnodes {
        return null;
    }
}