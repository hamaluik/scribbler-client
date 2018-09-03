package ui.components;

import mithril.M;
import util.Ref;

@:native("SimpleMDE")
extern class SimpleMDE {
    public function new(options:Dynamic);
    public function toTextArea():Void;
    public function value():String;
    public var codemirror:{
        on:Dynamic
    };
}

class MarkdownEditor implements Mithril {
    var value:String = "";
    var mde:SimpleMDE = null;

    public static function oncreate(vnode: Vnode<MarkdownEditor>):Void {
        vnode.state.mde = new SimpleMDE({
            element: vnode.dom,
            autofocus: true,
            forceSync: true,
            initialValue: vnode.state.value,
        });

        vnode.state.mde.codemirror.on("change", function() {
            vnode.state.value = vnode.state.mde.value();
            var value_ref:Ref<String> = vnode.attrs.get('value');
            value_ref.set(vnode.state.mde.value());
        });
    }

    public static function view(vnode: Vnode<MarkdownEditor>): Vnodes {
        var value:Ref<String> = vnode.attrs.get('value');
        vnode.state.value = value;

        return m('textarea', {
            value: vnode.state.value,
            onchange: M.withAttr('value', function(v:String):Void {
                vnode.state.value = v;
                value.set(v);
            }),
            onblur: vnode.attrs.get('onblur'),
        });
    }

    public static function onbeforeremove(vnode: Vnode<MarkdownEditor>):Void {
        vnode.state.mde.toTextArea();
        vnode.state.mde = null;
    }
}