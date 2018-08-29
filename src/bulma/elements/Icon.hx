package bulma.elements;

import mithril.M;

class Icon implements Mithril {
    public static function view(node:Vnode<Icon>): Vnodes {
        return m("span.icon[aria-hidden]", [
            m('i.fas.fa-${node.attrs.get('glyph')}')
        ]);
    }
}