package util;

class RefObject<T> {
    public var value:T;
    public var onChanged:Option<T->Void> = None;

    public function new(value:T, ?onChanged:T->Void) {
        this.value = value;
        if(onChanged != null) this.onChanged = Some(onChanged);
    }

    public function set(value:T):T {
        this.value = value;

        switch(onChanged) {
            case Some(c): c(value);
            case None: {}
        }

        return value;
    }

    public function setWithoutTrigger(value:T):T {
        return this.value = value;
    }
}

@:forward abstract Ref<T>(RefObject<T>) {
    public inline function new(value:T)
        this = new RefObject<T>(value);

    @:from static function ofConstant<T>(value:T):Ref<T>
        return new Ref(value);

    @:to function toValue():T
        return this.value;
}