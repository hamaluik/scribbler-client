package data.state;

abstract IDMapState<T>({}) from {} to {} {
    inline public function exists(id:Null<String>):Bool {
        return id != null && Reflect.hasField(this, Std.string(id));
    }

    inline public function get(id:Null<String>):Option<T> {
        return
            if(id == null || !exists(id)) None;
            else Some(Reflect.field(this, Std.string(id)));
    }

    inline public function getAll():Array<T> {
        return Reflect.fields(this).map(function(id:String):T {
            return Reflect.field(this, Std.string(id));
        });
    }
}