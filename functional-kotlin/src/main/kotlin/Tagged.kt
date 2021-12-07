data class Foo(val a: Int, val b: Int)

// T: Phantom-Typ
data class Tagged<T, out A>(val value: A)

class NonZero {}
fun nonZero(foo: Tagged<Nothing, Foo>): Option<Tagged<NonZero, Foo>> =
    if (foo.value.a != 0 && foo.value.b != 0)
        Some(Tagged(foo.value))
    else
        None

class Greater {}
fun greater(foo: Tagged<NonZero, Foo>): Option<Tagged<Greater, Foo>> =
    if (foo.value.a > foo.value.b)
        Some(Tagged(foo.value))
    else
        None

