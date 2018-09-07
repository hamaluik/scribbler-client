package bulma.forms;

import mithril.M;
import util.Ref;

class TextField implements Mithril {
    var value:String = "";

    public static function view(vnode: Vnode<TextField>): Vnodes {
        var classes:String = '';
        if(vnode.attrs.get('expanded')) classes += '.is-expanded';
        if(vnode.attrs.get('loading')) classes += '.is-loading';
        if(vnode.attrs.exists('icon_left')) classes += '.has-icons-left';
        if(vnode.attrs.exists('icon_right')) classes += '.has-icons-right';

        var type:String = switch(vnode.attrs.get('type')) {
            case 'password': 'password';
            case 'email': 'email';
            default: 'text';
        }

        var value:Ref<String> = vnode.attrs.get('value');
        vnode.state.value = value;

        var icons_left: Vnodes = if(vnode.attrs.exists('icon_left'))
            m('span.icon.is-small.is-left', [
                m('i.fas.fa-' + vnode.attrs.get('icon_left'))
            ]);
        else null;
        var icons_right: Vnodes = if(vnode.attrs.exists('icon_right'))
            m('span.icon.is-small.is-right', [
                m('i.fas.fa-' + vnode.attrs.get('icon_right'))
            ]);
        else null;

        var size:String = '';
        if(vnode.attrs.exists('size')) {
            size = '.is-' + vnode.attrs.get('size');
        }

        return 
            m('.control${classes}', [
                m('input.input${size}', {
                    type: type,
                    placeholder: vnode.attrs.get('placeholder'),
                    value: vnode.state.value,
                    oninput: M.withAttr('value', function(v:String):Void { vnode.state.value = v; value.set(v); }),
                    //onchange: M.withAttr('value', function(v:String):Void { vnode.state.value = v; value.set(v); }),
                    readonly: vnode.attrs.get('readonly'),
                    disabled: vnode.attrs.get('disabled'),
                }),
                icons_left,
                icons_right
            ]);
    }
}