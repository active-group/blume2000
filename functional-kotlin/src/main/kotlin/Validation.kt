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

// Arrow-kt: Validated<E, A>
// Haskell: (Validated E) A