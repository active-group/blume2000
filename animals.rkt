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
  armadillo? ; Prädikat, nach dem Konstruktor
  (armadillo-liveness liveness)
  (armadillo-weight kg))

; Prädikat, vgl. instanceof
(: armadillo? (any -> boolean))

(define dillo1 (make-armadillo "alive" 10)) ; Gürteltier, lebendig, 10kg
(define dillo2 (make-armadillo "dead" 8)); Gürteltier, tot, 8kg

; Gürteltier am Leben?
(: armadillo-alive? (armadillo -> boolean))

(check-expect (armadillo-alive? dillo1) #t)
(check-expect (armadillo-alive? dillo2) #f)

(define armadillo-alive?
  (lambda (dillo)
    (string=? (armadillo-liveness dillo) "alive")))

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
  parrot?
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

; Ein Tier ist eins der folgenden:
; - Gürteltier
; - Papagei
; Fallunterscheidung, keine Aufzählung
; gemischten Daten
(define animal
  (signature
   (mixed armadillo parrot)))


; Tier überfahren
(: run-over-animal (animal -> animal))

(check-expect (run-over-animal dillo1)
              (run-over-dillo dillo1))
(check-expect (run-over-animal parrot1)
              (run-over-parrot parrot1))

(check-property
 (for-all ((d armadillo))
   (armadillo? (run-over-animal d))))

#;(check-property
 (for-all ((d animal))
   (parrot? (run-over-animal d))))

(define run-over-animal
  (lambda (animal)
    (cond
      ((armadillo? animal) (run-over-dillo animal))
      ((parrot? animal) (run-over-parrot animal)))))

; Ein Blumenstrauß ist eins der folgenden:
; - eine Blume
; - eine Kombinationsstrauß aus zwei Blumensträußen
;                                    ^^^^^^^^^^^^^^
;                                    Selbstreferenzen
(define blumenstrauß
  (signature
   (mixed blume
          kombinationsstrauß)))

; Eine Blume ist eins der folgenden:
; - Rose
; - Tulpe
; - Lilie
(define blume
  (signature
   (enum "Rose" "Tulpe" "Lilie")))

; Ist Objekt eine Blume?
(: blume? (any -> boolean))

(check-expect (blume? "Rose") #t)
(check-expect (blume? "Mike") #f)
(check-expect (blume? dillo1) #f)

(define blume?
  (lambda (object)
    (and (string? object)
         (or (string=? object "Rose")
             (string=? object "Tulpe")
             (string=? object "Lilie")))))

; Ein Kombinationsstrauß besteht aus:
; - ein Blumenstrauß
; - noch ein Blumenstrauß
(define-record kombinationsstrauß
  make-kombinationsstrauß
  kombinationsstrauß?
  (kombination-strauß1 blumenstrauß)
  (kombination-strauß2 blumenstrauß))

; (: + (number number -> number))
; (: overlay (image image -> image))
(: make-kombinationsstrauß (blumenstrauß blumenstrauß -> blumenstrauß))

(: strauß1 blumenstrauß)
(define strauß1 "Rose")
(: strauß2 blumenstrauß)
(define strauß2 "Lilie")
(: strauß3 blumenstrauß)
(define strauß3 (make-kombinationsstrauß strauß1 strauß2))
(: strauß4 blumenstrauß)
(define strauß4 (make-kombinationsstrauß "Tulpe" "Lilie"))
(define strauß5 (make-kombinationsstrauß strauß3 strauß4))

; Wieviele Blumen einer Sorte im Blumenstrauß?
(: wieviele-blumen (blumenstrauß blume -> natural))

(check-expect (wieviele-blumen strauß3 "Rose") 1)
(check-expect (wieviele-blumen strauß5 "Lilie") 2)

(define wieviele-blumen
  (lambda (blumenstrauß blume)
    (cond
      ((blume? blumenstrauß)
       (if (string=? blume blumenstrauß)
           1
           0))
      ((kombinationsstrauß? blumenstrauß)
       (+ (wieviele-blumen (kombination-strauß1 blumenstrauß) blume)
          (wieviele-blumen (kombination-strauß2 blumenstrauß) blume))))))

; Eine Liste ist eins der folgenden:
; - die leere Liste
; - eine Cons-Liste aus erstem Element und Rest-Liste
;                                               ^^^^^ Selbstbezug
(: list-of (signature -> signature))
(define list-of
  (lambda (element)
    (signature
     (mixed empty-list
            (cons-list-of element)))))

#;(define list-of-numbers
  (signature
   (mixed empty-list
          cons-list)))


; Die leere Liste hat keine Eigenschaften
(define-record empty-list
  make-empty-list
  empty?
  ; keine Felder
  )

(define empty (make-empty-list)) ; "die" leere Liste

; Eine Cons-Liste besteht aus:
; - erstes Element
; - Rest-Liste
(define-record (cons-list-of element) ; implizites Lambda
  cons
  cons?
  (first element)
  (rest (list-of element)))

; alte Version
#;(define-record cons-list
  cons
  cons?
  (first number)
  (rest list-of-numbers))

(define list-of-numbers (signature (list-of number)))

(define l1 (cons 17 empty)) ; 1elementige Liste: 17
(define l2 (cons 3 (cons 17 empty))) ; 2elementige Liste: 3 17
(define l3 (cons 5 l2)) ; 3elementige Liste: 5 3 17

; Summe der Listenelemente berechnen
(: list-sum ((list-of number) -> number))

(check-expect (list-sum l3) 25)

(define list-sum
  (lambda (list)
    (cond
      ((empty? list) 0) ; neutrales Element
      ((cons? list)
       (+ (first list) ; erstes Element
          (list-sum (rest list))))))) ; Summe der restlichen Elemente

; Sind alle Zahlen einer Liste gerade?
(: all-even? (list-of-numbers -> boolean))

(check-expect (all-even? (cons 2 (cons 4 (cons 6 empty))))
              #t)
(check-expect (all-even? (cons 2 (cons 3 (cons 8 empty))))
              #f)

(define all-even?
  (lambda (list)
    (cond
      ((empty? list) #t) ; neutrales Element
      ((cons? list)
       (and (even? (first list))
            (all-even? (rest list)))))))

; Sind alle Zahlen einer Liste positiv?
(: all-positive? (list-of-numbers -> boolean))

(check-expect (all-positive? (cons 2 (cons 3 (cons 4 (cons 1 empty)))))
              #t)
(check-expect (all-positive? (cons 2 (cons -1 (cons 4 empty))))
              #f)

(define all-positive?
  (lambda (list)
    (cond
      ((empty? list) #t)
      ((cons? list)
       (and (positive? (first list))
            (all-positive? (rest list)))))))

; (: positive? (number -> boolean))

; Haben alle Elemente der Liste eine bestimmte Eigenschaft?
; %element: Signaturvariable
; abstraktere Signatur, aber genauer
(: all? ((%element -> boolean) (list-of %element) -> boolean))

; vorher:
;(: all? ((number -> boolean) (list-of number) -> boolean))

; Higher-Order-Funktion

(check-expect (all? even? (cons 2 (cons 4 (cons 6 empty))))
              #t)
(check-expect (all? even? (cons 2 (cons 5 (cons 6 empty))))
              #f)

(check-property
 (for-all ((list list-of-numbers))
   (expect (all? positive? list)
           (all-positive? list))))

(define all?
  (lambda (p? list)
    (cond
      ((empty? list) #t)
      ((cons? list)
       (and (p? (first list))
            (all? p? (rest list)))))))


 