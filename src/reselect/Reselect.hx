package reselect;

@:native('Reselect')
extern class Reselect {
    @:overload(function <S, R1, T>(selector1:S->R1, combiner:R1->T):S->T {})
    @:overload(function <S, R1, R2, T>(selector1:S->R1, selector2:S->R2, combiner:R1->R2->T):S->T {})
    @:overload(function <S, R1, R2, R3, T>(selector1:S->R1, selector2:S->R2, selector3:S->R3, combiner:R1->R2->R3->T):S->T {})
    @:overload(function <S, R1, R2, R3, R4, T>(selector1:S->R1, selector2:S->R2, selector3:S->R3, selector4:S->R4, combiner:R1->R2->R3->R4->T):S->T {})
    public static function createSelector<S, R1, R2, R3, R4, R5, T>(selector1:S->R1, selector2:S->R2, selector3:S->R3, selector4:S->R4, selector5:S->R5, combiner:R1->R2->R3->R4->R5->T):S->T;
}