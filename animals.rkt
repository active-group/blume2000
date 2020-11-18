;; Die ersten drei Zeilen dieser Datei wurden von DrRacket eingefügt. Sie enthalten Metadaten
;; über die Sprachebene dieser Datei in einer Form, die DrRacket verarbeiten kann.
#reader(lib "beginner-reader.rkt" "deinprogramm" "sdp")((modname animals) (read-case-sensitive #f) (teachpacks ()) (deinprogramm-settings #(#f write repeating-decimal #f #t none explicit #f ())))
; Lebendigkeit ist eins der folgenden:
; - tot
; - lebendig
(define liveness
  (signature (enum "dead" "alive")))

(define kg
  (signature
   natural))

; Ein Gewicht hat folgende Eigenschaft:
; - eine Zahl mit g
(define-record weight
  make-weight-from-g
  (weight-g number))

(: make-weight-from-kg (number -> weight))

(define make-weight-from-kg
  (lambda (kg)
    (make-weight-from-g (* 1000 kg))))

(define weight-kg
  (lambda (weight)
    (/ (weight-g weight) 1000)))

#|
class Weight {
  private final double kg;
  public double getKg() {
    return this.kg;
  }
}

Weight w ...;

... w.kg ...
|#

; Gewicht aus Anzahl g erzeugen
#;(: make-weight-from-g (natural -> weight))

(check-expect (make-weight-from-g 1500)
              (make-weight-from-kg 1.5))
 
#;(define make-weight-from-g
  (lambda (g)
    (make-weight-from-kg (/ g 1000))))



; Ein Gürteltier hat folgende Eigenschaften:
; - tot oder lebendig
; - Gewicht
; zusammengesetzte Daten
; Zustand zu einem bestimmten Zeitpunkt:
(define-record armadillo
  make-armadillo
  (armadillo-liveness liveness)
  (armadillo-weight kg))

(define dillo1 (make-armadillo "alive" 10)) ; Gürteltier, lebendig, 10kg
(define dillo2 (make-armadillo "dead" 8)); Gürteltier, tot, 8kg

; Gürteltier überfahren
; Java: class Armadillo { void runOver() { this.liveness = Dead } }
(: run-over-dillo (armadillo -> armadillo))

(check-expect (run-over-dillo dillo1)
              (make-armadillo "dead" 10))
(check-expect (run-over-dillo dillo2)
              dillo2)

(define run-over-dillo
  (lambda (dillo)
    (make-armadillo "dead"
                    (armadillo-weight dillo))))

#;(cond
  ((string=? (dillo-liveness dillo1) "dead") ...)
  ((string=? (dillo-liveness dillo1) "alive") ...))

#;(cond
  ((string=? (dillo-liveness dillo1) "dead") ...)
  (else ...))

#;(if (string=? (dillo-liveness dillo1) "dead")
    ... ; Konsequente, "then-Zweig"
    ...) ; Alternative, "else-Zweig"


; Gürteltier füttern
(: feed-dillo (armadillo kg -> armadillo))

(check-expect (feed-dillo dillo1 3)
              (make-armadillo "alive" 13))
(check-expect (feed-dillo dillo2 5)
              dillo2)

(define feed-dillo
  (lambda (dillo amount)
    (make-armadillo (armadillo-liveness dillo)
                    (cond
                      ((string=? (armadillo-liveness dillo) "dead")
                       (armadillo-weight dillo))
                      ((string=? (armadillo-liveness dillo) "alive")
                       (+ (armadillo-weight dillo) amount))))))

; Ein Papagei hat folgende Eigenschaften:
; - Satz
; - Gewicht
(define-record parrot
  make-parrot
  (parrot-sentence string)
  (parrot-weight kg))

(define parrot1 (make-parrot "Hello!" 1)) ; Papagei mit Begrüßung, 1kg
(define parrot2 (make-parrot "Tschüssi!" 2)) ; Papagei mit Verabschiedung, 2kg

; Papagei überfahren
(: run-over-parrot (parrot -> parrot))

(check-expect (run-over-parrot parrot1)
              (make-parrot "" 1))
(check-expect (run-over-parrot parrot2)
              (make-parrot "" 2))

(define run-over-parrot
  (lambda (parrot)
    (make-parrot "" (parrot-weight parrot))))

; Papagei füttern
(: feed-parrot (parrot kg -> parrot))

(check-expect (feed-parrot parrot1 3)
              (make-parrot "Hello!" 4))
(check-expect (feed-parrot parrot2 1)
              (make-parrot "Tschüssi!" 3))

(define feed-parrot
  (lambda (parrot amount)
    (make-parrot (parrot-sentence parrot)
                 (+ (parrot-weight parrot) amount))))
    