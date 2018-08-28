package ui.routes;

import mithril.M;
import bulma.forms.TextField;

class SignUp implements Mithril {

    var signup_name:Ref<String> = "";
    var pass1:Ref<String> = "";
    var pass2:Ref<String> = "";
    var reg_key:Ref<String> = "";

    var signing_up:Bool = false;
    var error_msg:Option<String> = None;

    @:allow(App) private function new() {
        signup_name.onChanged = Some(function(_) {
            error_msg = None;
        });
        pass1.onChanged = Some(function(_) {
            error_msg = None;
            if(pass1.value != pass2.value) {
                error_msg = Some("Passwords must match!");
            }
        });
        pass2.onChanged = Some(function(_) {
            error_msg = None;
            if(pass1.value != pass2.value) {
                error_msg = Some("Passwords must match!");
            }
        });
        reg_key.onChanged = Some(function(_) {
            error_msg = None;
        });
    }

    public function onmatch(args: haxe.DynamicAccess<String>, requestedPath: String) {
        if(!App.store.getState().auth.token.match(None)) M.routeSet('/');
        return null;
    }

    function signUp(e:js.html.Event) {
        e.preventDefault();

        signing_up = true;
        M.redraw();
        api.Auth.signUp(signup_name.value, pass1.value, reg_key)
            .then(function(_) {
                signing_up = false;
                M.routeSet("/signin");
            })
            .catchError(function(err) {
                js.Browser.console.error(err);
                signing_up = false;
                error_msg = Some("Unauthorized.");
                M.redraw();
            });
    }

    public function render(vnode: Vnode<SignIn>): Vnodes {
        var error_display:Vnodes = switch(error_msg) {
            case Some(msg): m('.notification.is-danger', [
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
            m('section.hero.is-fullheight.is-bg', [
                m('.hero-body', [
                    m('.container', [
                        m('.columns.is-centered', [
                            m('.column.is-one-third', [
                                m('.box.content', [
                                    m("form", {
                                        onsubmit: signUp,
                                        action: "#"
                                    }, [
                                        m('h1', 'Scribbler: Sign Up'),
                                        m('.field', [
                                            m('label.label', 'Name'),
                                            m(TextField, {
                                                type: 'text',
                                                icon_left: 'user-tag',
                                                value: signup_name,
                                                placeholder: 'Bob'
                                            })
                                        ]),
                                        m('.field', [
                                            m('label.label', 'Password'),
                                            m(TextField, {
                                                type: 'password',
                                                icon_left: 'key',
                                                value: pass1,
                                                placeholder: '****************'
                                            })
                                        ]),
                                        m('.field', [
                                            m('label.label', 'Password (Again)'),
                                            m(TextField, {
                                                type: 'password',
                                                icon_left: 'key',
                                                value: pass2,
                                                placeholder: '****************'
                                            })
                                        ]),
                                        m('.field', [
                                            m('label.label', 'Registration Key'),
                                            m(TextField, {
                                                type: 'text',
                                                icon_left: 'passport',
                                                value: reg_key,
                                                placeholder: ''
                                            })
                                        ]),
                                        error_display,
                                        m('.notification.is-warning', [
                                            m('b', "Note:"),
                                            " All of your notes will be encrypted using this password, and this password is the only thing that can unlock them. There is no password reset or data recovery without this password. Make it a good one."
                                        ]),
                                        m('.field.is-grouped.is-grouped-right', [
                                            m('.control', [
                                                m('a.button', {
                                                    href: "#!/signin"
                                                }, [
                                                    m("span.icon", m("i.fas.fa-backward")),
                                                    m("span", " Sign In")
                                                ])
                                            ]),
                                            m('.control', [
                                                m('button.button.is-primary' + (signing_up ? '.is-loading' : ''), {
                                                    type: "submit"
                                                }, [
                                                    m("span.icon", m("i.fas.fa-user-plus")),
                                                    m("span", "Sign Up"),
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