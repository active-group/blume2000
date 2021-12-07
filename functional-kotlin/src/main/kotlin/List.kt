// Listen in Kotlin
// FP-Methoden: filter map
// drunter: ArrayList

// Eine Liste ist eins der folgenden:
// - die leere Liste
// - eine Cons-Liste besteht aus erstem Element und Rest-Liste
//                                                       ^^^^^ Selbstreferenz
// gemischte Daten
// Kotlin: ein Interface obendrüber, Unterklassen
sealed interface List<out A>

// Angenommen A < B
// Wie ist die Beziehung zwischen List<A> und List<B>?
// Varianz: Kovarianz List<A> < List<B>
// Kontravarianz wäre List<A> > List<B>
// Default in Kotlin (?): No-Varianz

object Empty : List<Nothing>

// "construct"
// Haskell :
// zusammengesetzte Daten
data class Cons<out A>(val first: A, val rest: List<A>) : List<A>

// Summe aller Listenelemente
// wir brauchen: List<Nothing> < List<Int> für Empty
tailrec fun listSum(list: List<Int>): Int =
    when (list) {
        is Empty -> 0
        is Cons ->
            // list.first + []: Kontext des Aufrufs von listSum
            list.first + listSum(list.rest)
    }

tailrec fun listSum1(list: List<Int>, acc: Int = 0): Int =
    when (list) {
        is Empty -> acc
        is Cons ->
            // kein Kontext, endrekursiv
            listSum1(list.rest, acc + list.first)
    }

val list1 = Cons(1, Empty)
val list2 = Cons(1, Cons(2, Empty))
// 3elementige Liste: 3 5 7
val list3 = Cons(3, Cons(5, Cons(7, Empty)))
val list4 = Cons(1, list3)