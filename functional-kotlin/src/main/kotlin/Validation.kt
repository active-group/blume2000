// Validieren
// Etwas validiertes ist eins der folgenden:
// - entweder ist alles richtig: ein Ergebnis
// - ODER es gibt eine Liste von Problemen
sealed interface Validated<out A, out E>
data class Valid<out A>(val result: A) : Validated<A, Nothing>
data class Invalid<out E>(val errors: List<E>): Validated<Nothing, E>

fun <A, B, E> validatedMap(f: (A) -> B, v: Validated<A, E>): Validated<B, E> =
    when (v) {
        is Valid -> Valid(f(v.result))
        is Invalid -> Invalid(v.errors)
    }


fun <A, B, C, E> validatedMap2(f: (A, B) -> C, va: Validated<A, E>, vb: Validated<B, E>): Validated<C, E> =
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

fun <A, B, E> validateAp(f: Validated<(A) -> B, E>, v: Validated<A, E>): Validated<B, E> = TODO()

// flatMap inhärent sequenziell // Abhängigkeit
fun <A, B, E> validatedFlatMap(f: (A) -> Validated<B, E>, v: Validated<A, E>): Validated<B, E> =
    when (v) {
        is Valid -> f(v.result)
        is Invalid -> v // Invalid(v.errors)
    }
// Arrow-kt: Validated<E, A>
// Haskell: (Validated E) A