package ui.components;

import mithril.M;
import util.Ref;

class MarkdownEditor implements Mithril {
    var value:String = "";

    public static function view(vnode: Vnode<MarkdownEditor>): Vnodes {
        var value:Ref<String> = vnode.attrs.get('value');
        vnode.state.value = value;

        return m('textarea', {
            placeholder: vnode.attrs.get('placeholder'),
            value: vnode.state.value,
            onchange: M.withAttr('value', function(v:String):Void {
                vnode.state.value = v;
                value.set(v);
            }),
            onblur: vnode.attrs.get('onblur'),
            readonly: vnode.attrs.get('readonly'),
            disabled: vnode.attrs.get('disabled'),
        });
    }
}