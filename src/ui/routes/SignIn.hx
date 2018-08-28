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
        var signup_display:Vnodes = if(App.store.getState().auth.signed_up) {
            m('.notification', "You've successfully signed up! You can now sign in with the name and password you supplied previously.");
        }
        else null;

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
            m('section.hero.is-fullheight.is-bg', [
                m('.hero-body', [
                    m('.container', [
                        m('.columns.is-centered', [
                            m('.column.is-one-third', [
                                m('.box.content', [
                                    m("form", {
                                        onsubmit: signIn,
                                        action: "#"
                                    }, [
                                        m('h1', 'Scribbler: Sign In'),
                                        signup_display,
                                        m('.field', [
                                            m('label.label', 'Name'),
                                            m(TextField, {
                                                type: 'text',
                                                icon_left: 'user-tag',
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
                                                    m("span.icon", m("i.fas.fa-user-plus")),
                                                    m("span", "Sign Up")
                                                ])
                                            ]),
                                            m('.control', [
                                                m('button.button.is-primary' + (signing_in ? '.is-loading' : ''), {
                                                    type: "submit"
                                                }, [
                                                    m("span.icon", m("i.fas.fa-unlock")),
                                                    m("span", "Sign In"),
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