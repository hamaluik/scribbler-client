package bulma.elements;

import mithril.M;

class Icon implements Mithril {
    public static function view(node:Vnode<Icon>): Vnodes {
        var style:Null<String> = node.attrs.get('style');
        if(style == null) style = 'fas';
        
        return m("span.icon[aria-hidden]", [
            m('i.${style}.fa-${node.attrs.get('glyph')}')
        ]);
    }
}