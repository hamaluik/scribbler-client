package ui.routes;

import mithril.M;
import ui.components.ControlPane;
import ui.components.EditToolbar;
import ui.components.Footer;
import ui.components.NoteHeader;
import ui.components.TagList;

class View implements Mithril {
    @:allow(App) private function new(){}

    public function onmatch(args: haxe.DynamicAccess<String>, requestedPath: String) {
        if(App.store.getState().auth.token.match(None)) M.routeSet('/signin');
        return null;
    }

    public function render(vnode: Vnode<View>): Vnodes {
        var rendered_html:String = App.markdown.render("");

        var id:Null<String> = M.routeAttrs(vnode).get('id');

        return [
            m('.is-fullheight', [
                m('.columns.is-gapless', [
                    m(ControlPane),
                    m('.column', [
                        m(NoteHeader, { id: id, editable: false }),
                        m(EditToolbar, { id: id }),
                        m('section.content', M.trust(rendered_html))
                    ])
                ])
            ]),
            m(Footer)
        ];
    }
}