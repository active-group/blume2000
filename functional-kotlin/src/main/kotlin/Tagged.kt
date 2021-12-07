data class Foo(val a: Int, val b: Int)

// T: Phantom-Typ
data class Tagged<T, out A>(val value: A)

abstract class NonZero {}
fun <A> nonZero(foo: Tagged<A, Foo>): Option<Tagged<NonZero, Foo>> =
    if (foo.value.a != 0 && foo.value.b != 0)
        Some(Tagged(foo.value))
    else
        None

abstract class Greater : NonZero() {}
fun greater(foo: Tagged<NonZero, Foo>): Option<Tagged<Greater, Foo>> =
    if (foo.value.a > foo.value.b)
        Some(Tagged(foo.value))
    else
        None

val foo1: Tagged<NonZero, Foo> = Tagged(Foo(1, -1))
val foo2 = nonZero(foo1)
val foo3 = foo2.flatMap { greater(it) }