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

sealed interface DB
data class Get(val key: String, val cont: (Int) -> DB)
data class Put(val key: String, val value: Int, val cont: (Unit) -> DB)
data class Done(result: Int)

val p1 = Put("Mike", 50) {
         Get("Mike") { x ->
         Put("Mike", x+1) {
         Get("Mike") { y ->
             Done(x + y)
         }    
         }
}
