// Idee:
// Domäne liefert eine Beschreibung des Ablaufs
// Bsp: Validierung, Verfügbarkeit prüfen etc.

// "Ablauf"
// Datenbank-Programm, besteht aus get und put
// put("Mike", 50)
// x <- get("Mike")
// put("Mike", x + 1)
// y <- get("Mike")
// return x + y

// sealed interface DBCommand
// data class Get(val key: String): DBCommand
// data class Put(val key: String, val value: String): DBCommand

// DBProgram = List<DBCommand>

// Wie etwas einen Namen geben?
// FP: Lambda!
// NodeJS: Callback, FP: Continuation

// Datenbank-Programm, das ein Ergebnis vom Typ A liefert
sealed interface DB<out A> {
    fun <B> map(f: (A) -> B): DB<B> = dbMap(f, this)
    fun <B> flatMap(f: (A) -> DB<B>): DB<B> = splice(this, f)
}

data class Get<out A>(val key: String, val cont: (Int) -> DB<A>): DB<A>
data class Put<out A>(val key: String, val value: Int, val cont: (Unit) -> DB<A>): DB<A>
data class Done<out A>(val result: A): DB<A>

val p1 = Put("Mike", 50) {
         Get("Mike") { x ->
         Put("Mike", x+1) {
         Get("Mike") { y ->
             Done(x + y)
         }
         }
             }}

fun get(key: String): DB<Int> = Get(key, { value -> Done(value)} )
fun put(key: String, value: Int): DB<Unit> =
    Put(key, value, { unit -> Done(unit)} )

val p1_ = put("Mike", 50).flatMap {
          get("Mike").flatMap { x ->
          put("Mike", x + 1).flatMap {
          get("Mike").flatMap { y ->
          Done(x+y)
          }
          }
}}


// DB ist eine Monade

fun <A, B> splice(dba: DB<A>, dbf: (A) -> DB<B>): DB<B> =
    when (dba) {
        is Get -> Get(dba.key, { value -> splice(dba.cont(value), dbf) })
        is Put -> Put(dba.key, dba.value, { unit -> splice(dba.cont(unit), dbf) })
        is Done -> dbf(dba.result)
    }

// gehört in den Adapter
tailrec fun <A> runDB(db: DB<A>, storage: MutableMap<String, Int>): A =
    when (db) {
        is Get ->
             runDB(db.cont(storage[db.key]!!), storage)
        is Put -> {
            storage[db.key] = db.value
            // runDB(db.cont(Unit), storage + Pair(db.key, db.value))
            runDB(db.cont(Unit), storage)
        }
        is Done -> db.result
    }

fun <A, B> dbMap(f: (A) -> B, db: DB<A>): DB<B> =
    when (db) {
        is Get -> Get(db.key)           { value -> dbMap(f, db.cont(value)) }
        is Put -> Put(db.key, db.value) { unit  -> dbMap(f, db.cont(unit))  }
        is Done -> Done(f(db.result))
    }

// Im Lambda-Kalkül gibt es nur Funktionen mit 1 Parameter / 1 Rückgabe
// Was tun mit Funktionen, die mehrere Eingaben haben?
fun add(a: Int, b: Int): Int = a + b

fun add1(a: Int): (Int) -> Int = { b -> a + b}

// add1(a)(b)
// Haskell add1 a b == (add1 a) b

// Haskell B. Curry
// Moses Schönfinkel
fun <A, B, C> curry(f: (A, B) -> C): (A) -> (B) -> C =
    { a -> { b -> f(a, b)}}

