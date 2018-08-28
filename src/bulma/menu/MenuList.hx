package bulma.menu;

import mithril.M;

class MenuList implements Mithril {
    public static function view(node:Vnode<MenuList>): Vnodes {
        return [
            m("p.menu-label", node.attrs.get('label')),
            m("ul.menu-list", node.children)
        ];
    }
}