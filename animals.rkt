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
    
