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
sealed interface DB<out A>
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

fun <A> runDB(db: DB<A>, storage: Map<String, Int>): A = TODO()
