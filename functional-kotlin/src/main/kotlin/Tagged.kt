data class Foo(val a: Int, val b: Int)

// T: Phantom-Typ
data class Tagged<T, out A>(val value: A)

class NonZero {}
fun nonZero(foo: Tagged<Nothing, Foo>): Tagged<NonZero, Foo> =
    Tagged(foo.value.a != 0 && foo.value.b != 0)

class Greater {}
fun greater(foo: Foo): Boolean = foo.a > foo.b

