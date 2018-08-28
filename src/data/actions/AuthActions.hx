package data.actions;

enum AuthActions {
    SignUp;
    SignIn(token:String);
    SignOut;
}