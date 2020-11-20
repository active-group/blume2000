;; Die ersten drei Zeilen dieser Datei wurden von DrRacket eingefügt. Sie enthalten Metadaten
;; über die Sprachebene dieser Datei in einer Form, die DrRacket verarbeiten kann.
#reader(lib "vanilla-reader.rkt" "deinprogramm" "sdp")((modname validation) (read-case-sensitive #f) (teachpacks ()) (deinprogramm-settings #(#f write repeating-decimal #f #t none explicit #f ())))
; (: map ((%a -> %b) (list-of %a) -> (list-of %b)))
; (: set-map ((%a -> %b) (set-of %a) -> (set-of %b)))
; Map<K, V>
; (: map-map ((%a -> %b) (map-of %k %a) -> (map-of %k %b)))

; Java 8:
; class Optional<T> {
;    <U> Optional<U> map(Function<? super T,? extends U> mapper)
;    <U> Optional<U> map(Function<T, U> mapper)
; }

; Funktor
; Zutat: 1 Typ-/Signaturkonstruktor
; + Operation map
; (map (lambda (x) x) list) == list
; (map (o f g) list) == (o ((curry map) f) ((curry map) g))

(: o ((%b -> %c) (%a -> %b) -> (%a -> %c)))

(define o
  (lambda (f g)
    (lambda (x)
      (f (g x)))))

(define liveness
  (signature (enum "dead" "alive")))

(define kg
  (signature
   natural))

; Ein Gürteltier hat folgende Eigenschaften:
; - tot oder lebendig
; - Gewicht
; zusammengesetzte Daten
; Zustand zu einem bestimmten Zeitpunkt:
(define-record (armadillo-of weight)
  make-armadillo
  armadillo? ; Prädikat, nach dem Konstruktor
  (armadillo-liveness liveness)
  (armadillo-weight weight))

; Ein Papagei hat folgende Eigenschaften:
; - Satz
; - Gewicht
(define-record (parrot-of weight)
  make-parrot
  parrot?
  (parrot-sentence string)
  (parrot-weight weight))

(define animal-of
  (lambda (weight)
    (signature
     (mixed (armadillo-of weight)
            (parrot-of weight)))))

(: run-over-dillo ((armadillo-of %weight) -> (armadillo-of %weight)))


(define run-over-dillo
  (lambda (dillo)
    (make-armadillo "dead"
                    (armadillo-weight dillo))))

; Jetzt aber ... Validierung

; Ein Fehlschlag hat folgende Eigenschaft:
; - eine Beschreibung des Fehlers
(define-record (failure-of description)
  make-failure
  failure?
  (failure-descriptions (list-of description))) ; verallgemeinerbar auf beliebige Monoiden

; Ein Erfolg hat folgende Eigenschaft:
; - Ergebnis
(define-record (success-of result)
  make-success
  success?
  (success-result result))

; Eine Validierung ist eins der folgenden:
; - Fehlschlag
; - Erfolg
(define validation
  (lambda (description result)
    (signature
     (mixed (failure-of description)
            (success-of result)))))

; Funktor für validation
(: validation-map ((%a -> %b) (validation %description %a) -> (validation %description %b)))



#|
interface Validation<D, R> { ... }

class Failure<D> extends Validation<D, ?> { ... }

class Success<R> extends Validation<?, R> { ... }
|#

(define age-error-description
  (signature
   (enum "too-young" "too-old")))

; Ein Alter hat folgende Eigenschaft:
; - Anzahl von Jahren
(define-record age
  make-age ; geheim
  age?
  (age-years natural))

; Alter validieren
; - keine Exceptions
; - nicht einfach Boolean, sondern sinnvolles Ergebnis
(: validate-age (natural -> (validation age-error-description age)))

(check-expect (validate-age 14) (make-failure (list "too-young")))
(check-expect (validate-age 30) (make-success (make-age 30)))
(check-expect (validate-age 140) (make-failure (list "too-old")))

(define validate-age
  (lambda (n)
    (cond
      ((< n 18) (make-failure (list "too-young")))
      ((> n 130) (make-failure (list "too-old")))
      (else (make-success (make-age n))))))

; Name hat folgende Eigenschaft:
; - Text des Namens
(define-record name
  make-name
  name?
  (name-text string))

(define name-error-description
  (signature
   (enum "Nazi" "Cartoon")))

; Name validieren
(: validate-name (string -> (validation name-error-description name)))

(define validate-name
  (lambda (text)
    (cond
      ((string=? "Hitler" text) (make-failure (list "Nazi")))
      ((string=? "Micky Maus" text) (make-failure (list "Cartoon")))
      (else (make-success (make-name text))))))











