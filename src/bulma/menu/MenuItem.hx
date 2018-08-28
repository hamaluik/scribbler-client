package bulma.menu;

import mithril.M;

/**
   attributes: active:Bool, link:String (/route/to/link/to)
   children: link visuals
 */
class MenuItem implements Mithril {
    public static function view(node:Vnode<MenuItem>): Vnodes {
        var is_active:String = node.attrs.get('active') ? '.is-active' : '';

        return m("li", [
            m('a${is_active}', { href: '#!' + node.attrs.get('link') }, node.children)
        ]);
    }
}