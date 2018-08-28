package bulma.menu;

import mithril.M;

class Menu implements Mithril {
    public static function view(node:Vnode<Menu>): Vnodes {
        return m("aside.menu", node.children);
    }
}