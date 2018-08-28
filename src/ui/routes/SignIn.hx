package ui.routes;

import mithril.M;
import bulma.forms.TextField;

class SignIn implements Mithril {

    var name:Ref<String> = "";
    var pass:Ref<String> = "";

    var signing_in:Bool = false;
    var error_msg:Option<String> = None;

    @:allow(App) private function new() {
        name.onChanged = Some(function(_) {
            error_msg = None;
        });
        pass.onChanged = Some(function(_) {
            error_msg = None;
        });
    }

    public function onmatch(args: haxe.DynamicAccess<String>, requestedPath: String) {
        if(!App.store.getState().auth.token.match(None)) M.routeSet('/');
        return null;
    }

    function signIn(e:js.html.Event) {
        e.preventDefault();

        signing_in = true;
        M.redraw();
        api.Auth.signIn(name.value, pass.value)
            .then(function(_) {
                signing_in = false;
                M.routeSet("/");
            })
            .catchError(function(err) {
                js.Browser.console.error(err);
                signing_in = false;
                error_msg = Some("Unrecognized name and/or password!");
                M.redraw();
            })
            .then(function(_) {
                // TODO: request notes from the server!
            });
    }

    public function render(vnode: Vnode<SignIn>): Vnodes {
        var error_display:Vnodes = switch(error_msg) {
            case Some(msg): m('.notification.is-warning', [
                m('button.delete', {
                    onclick: function() {
                        error_msg = None;
                        M.redraw();
                    }
                }),
                msg
            ]);
            case None: null;
        };

        return [
            // TODO: build components!
            m('section.hero.is-primary.is-fullheight', [
                m('.hero-body', [
                    m('.container', [
                        m('.columns.is-centered', [
                            m('.column.is-one-third', [
                                m('.box.content', [
                                    m("form", {
                                        onsubmit: signIn,
                                        action: "#"
                                    }, [
                                        m('h1', 'Sign in to Scribbler'),
                                        m('figure.image.is-3by2', { style: "margin: 0 2rem;" }, [
                                            m('img', { src: '/logo_3x2.svg' })
                                        ]),
                                        m('.field', [
                                            m('label.label', 'Name'),
                                            m(TextField, {
                                                type: 'text',
                                                icon_left: 'envelope',
                                                value: name,
                                                placeholder: 'Bob'
                                            })
                                        ]),
                                        m('.field', [
                                            m('label.label', 'Password'),
                                            m(TextField, {
                                                type: 'password',
                                                icon_left: 'key',
                                                value: pass,
                                                placeholder: '****************'
                                            })
                                        ]),
                                        error_display,
                                        m('.field.is-grouped.is-grouped-right', [
                                            m('.control', [
                                                m('a.button', {
                                                    href: "#!/signup"
                                                }, [
                                                    m("span", "Sign Up")
                                                ])
                                            ]),
                                            m('.control', [
                                                m('button.button.is-primary' + (signing_in ? '.is-loading' : ''), {
                                                    type: "submit"
                                                }, [
                                                    m("span", "Sign In")
                                                ])
                                            ]),
                                        ])
                                    ])
                                ])
                            ])
                        ])
                    ])
                ])
            ])
        ];
    }
}