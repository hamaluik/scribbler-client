package data.actions;

enum AuthActions {
    SignUp;
    SignIn(token:String);
    Refresh(token:String);
    SignOut;
}