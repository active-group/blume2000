// Validieren
// Etwas validiertes ist eins der folgenden:
// - entweder ist alles richtig: ein Ergebnis
// - ODER es gibt eine Liste von Problemen
sealed interface Validated<out A, out E> {
    // Varianzproblem
    // fun <B> ap(f: Validated<(A) -> B, E>): Validated<B, E> =
    //    validatedAp(f, this)
}
data class Valid<out A>(val result: A) : Validated<A, Nothing>
data class Invalid<out E>(val errors: List<E>): Validated<Nothing, E>

fun <A, B, E> Validated<(A) -> B, E>.ap(v: Validated<A, E>): Validated<B, E> =
    validatedAp(this, v)

fun <A, B, E> validatedMap(f: (A) -> B, v: Validated<A, E>): Validated<B, E> =
    when (v) {
        is Valid -> Valid(f(v.result))
        is Invalid -> Invalid(v.errors)
    }


fun <A, B, C, E> validatedMap2(f: (A, B) -> C, va: Validated<A, E>, vb: Validated<B, E>): Validated<C, E> =
    // curry(f): (A) -> ((B) -> C)
    validatedMap(curry(f), va).ap(vb)

fun <A, B, C, D, E> validatedMap3(f: (A, B, C) -> D, va: Validated<A, E>, vb: Validated<B, E>, vc: Validated<C, E>): Validated<D, E> =
    // curry(f): (A) -> ((B) -> C)
    validatedMap(curry3(f), va).ap(vb).ap(vc)
    // validatedAp(validatedAp(validatedMap(curry3(f), va), vb), vc)

fun <A, B, C, D> curry3(f: (A, B, C) -> D): (A) -> (B) -> (C) -> D =
    { a -> { b -> { c -> f(a, b, c)}}}

/*
    when (va) {
        is Valid ->
            when (vb) {
                is Valid -> Valid(f(va.result, vb.result))
                is Invalid -> Invalid(vb.errors)
            }
        is Invalid ->
            when (vb) {
                is Valid -> Invalid(va.errors)
                is Invalid -> Invalid(concat(va.errors, vb.errors))
            }
    }
*/

// applikativer Funktor / "Applicative"

// Funktor -> Applicative -> Monade

fun <A, B, E> validatedAp(f: Validated<(A) -> B, E>, v: Validated<A, E>): Validated<B, E> =
    when (f) {
        is Valid ->
            when (v) {
                is Valid -> Valid(f.result(v.result))
                is Invalid -> Invalid(v.errors)
            }
        is Invalid ->
            when (v) {
                is Valid -> Invalid(f.errors)
                is Invalid -> Invalid(concat(f.errors, v.errors))
            }
    }



// flatMap inhärent sequenziell // Abhängigkeit
fun <A, B, E> validatedFlatMap(f: (A) -> Validated<B, E>, v: Validated<A, E>): Validated<B, E> =
    when (v) {
        is Valid -> f(v.result)
        is Invalid -> v // Invalid(v.errors)
    }
// Arrow-kt: Validated<E, A>
// Haskell: (Validated E) A

// "parse, don't validate"
// parse number from string
fun numberString(text: String): Validated<Int, String> =
    text.toIntOrNull()?.let { n -> Valid(n) }
        ?: Invalid(Cons("not a number representation: $text", Empty))

val s1 = "123"
val s2 = "456"

fun addNumberStrings(n1: String, n2: String): Validated<Int, String> =
    validatedMap2(Int::plus, numberString(n1), numberString(n2))

