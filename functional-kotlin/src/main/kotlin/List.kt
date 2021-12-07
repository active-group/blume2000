// Listen in Kotlin
// FP-Methoden: filter map
// drunter: ArrayList

// Eine Liste ist eins der folgenden:
// - die leere Liste
// - eine Cons-Liste besteht aus erstem Element und Rest-Liste
//                                                       ^^^^^
// gemischte Daten
// Kotlin: ein Interface obendrüber, Unterklassen
sealed interface List<in A>

// Angenommen A < B
// Wie ist die Beziehung zwischen List<A> und List<B>?
// Varianz: Kovarianz List<A> < List<B>
// Kontravarianz wäre List<A> > List<B>
// Default in Kotlin (?): No-Varianz

object Empty : List<Nothing>

// "construct"
// Haskell :
// zusammengesetzte Daten
data class Cons<A>(val first: A, val rest: List<A>) : List<A>

// Summe aller Listenelemente
// wir brauchen: List<Nothing> < List<Int> für Empty
fun listSum(list: List<Int>): Int =
    when (list) {
        is Empty -> 0
        is Cons ->
            list.first + listSum(list.rest)
    }
