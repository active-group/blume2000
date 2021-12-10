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
fun listSum(list: List<Int>): Int =
    when (list) {
        is Empty -> 0
        is Cons ->
            // list.first + []: Kontext des Aufrufs von listSum
            list.first + listSum(list.rest)
    }

fun listProduct(list: List<Int>): Int =
    when (list) {
        is Empty -> 1
        is Cons ->
            list.first * listProduct(list.rest)
    }

fun <A, B> fold(e: B, f: (A, B) -> B, list: List<A>): B =
    when (list) {
        is Empty -> e
        is Cons ->
            f(list.first, fold(e, f, list.rest))
    }

fun listSum2(list: List<Int>): Int =
    fold(0, { a, b ->  a + b}, list)

tailrec fun listSum1(list: List<Int>, acc: Int = 0): Int =
    when (list) {
        is Empty -> acc
        is Cons ->
            // kein Kontext, endrekursiv
            listSum1(list.rest, acc + list.first)
    }

fun <A> concat(list1: List<A>, list2: List<A>): List<A> =
    when (list1) {
        is Empty -> list2
        is Cons ->
            // concat(1 2 3, 4 5 6)
            // list1.first = 1
            // concat(list1.rest, list2) = concat(2 3, 4 5 6) = 2 3 4 5 6
            Cons(list1.first, concat(list1.rest, list2))
    }

fun <A> concat2(list1: List<A>, list2: List<A>): List<A> =
    // eta-Expansion
    fold(list2, { f, r -> Cons(f, r) }, list1)

fun <A, B> listMap(f: (A) -> B, list: List<A>): List<B> =
    when (list) {
        is Empty -> Empty
        is Cons ->
            Cons(f(list.first), listMap(f, list.rest))
    }

fun <A, B> listFlatMap(f: (A) -> List<B>, list: List<A>): List<B> =
    when (list) {
        is Empty -> Empty
        is Cons ->
            concat(f(list.first), listFlatMap(f, list.rest))
    }

// Monade M ... M<A> ist ein Typ
// 2 Operationen:
// fun <A> unit(a: A): M<A>
// fun <A, B> flatMap(f: (A) -> M<B>, option: M<A>): M<B>
// auch genannt: "bind", Haskell: >>=

/*
interface Functor<F> { // hier darf leider kein Typ stehen, der einen Typparameter verlangt/braucht/hat
    fun <A, B> map(f: (A) -> B, thing: F<A>): F<B>
}

object listFunctor: Functor<List> {
    fun <A, B> map(f: (A) -> B, thing: List<A>): List<B> = listMap(f, thing)
}

object optionFunctor: Functor<Option> {
    fun <A, B> map(f: (A) -> B, thing: Option<A>): Option<B> = optionMap(f, thing)
}

object validatedFunctor<E>: Functor<Validated<???, E>>

// Haskell: Functor (Validated E)

 */

sealed interface Option<out A> {
    fun <B> map(f: (A) -> B) = optionMap(f, this)
    fun <B> flatMap(f: (A) -> Option<B>) = optionFlatMap(f, this)
}

object None : Option<Nothing>
data class Some<out A>(val value: A) : Option<A>

fun <A, B> optionMap(f: (A) -> B, option: Option<A>): Option<B> =
    when (option) {
        is None -> None
        is Some ->
            Some(f(option.value))
    }

fun <A, B> optionFlatMap(f: (A) -> Option<B>, option: Option<A>): Option<B> =
    when (option) {
        is None -> None
        is Some ->
            f(option.value)
    }

fun <A> listIndex(a: A, list: List<A>): Option<Int> =
    when (list) {
        is Empty -> None
        is Cons ->
            if (list.first == a)
                Some(0)
            else {
//                val r = listIndex(a, list.rest)
//                when (r) {
//                    is None -> None
//                    is Some ->
//                        Some(r.value + 1)
//                }
                listIndex(a, list.rest).map { index -> index + 1 }
            }
    }

data class Result1(val foo: Int)
data class Result2(val foo: Int)
data class Result3(val foo: Int)

fun step1(a: Int): Option<Result1> = TODO()
fun step2(b: Int): Option<Result2> = TODO()
fun step3(r1: Result1, r2: Result2): Int = TODO()

fun computation(a: Int, b: Int): Option<Int> =
    step1(a).flatMap { r1 ->
        step2(b).map { r2 -> step3(r1, r2) }
    }







val list1 = Cons(1, Empty)
val list2 = Cons(1, Cons(2, Empty))
// 3elementige Liste: 3 5 7
val list3 = Cons(3, Cons(5, Cons(7, Empty)))
val list4 = Cons(1, list3)