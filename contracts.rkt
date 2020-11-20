;; Die ersten drei Zeilen dieser Datei wurden von DrRacket eingefügt. Sie enthalten Metadaten
;; über die Sprachebene dieser Datei in einer Form, die DrRacket verarbeiten kann.
#reader(lib "vanilla-reader.rkt" "deinprogramm" "sdp")((modname contracts) (read-case-sensitive #f) (teachpacks ()) (deinprogramm-settings #(#f write repeating-decimal #f #t none explicit #f ())))
; Financial contracts / Finanzderivate

; Algebra
; Menge(n) + Operationen + Gleichungen für Operationen

; Menge: natürliche Zahlen
; Operation: +
; Assoziativgesetz
; => Die natürlichen Zahlen mit der Addition bilden eine Halbgruppe.
; => Die natürlichen Zahlen mit der Multiplikation bilden eine Halbgruppe.

; Halbgruppe, bei der auch ein neutrales Element vorhanden ist
; => Die natürlichen Zahlen mit der Addition bilden einen Monoid,
; bei dem 0 das neutrale Element ist.

; Halbgruppe -> Monoid -> Gruppe -> Ring -> Körper

; Programmierung: "Typ" statt "Menge"

; Voraussetzung:
; Menge/Typ/Signatur T
; Operation
; (: op (T T -> T))
; Beispiele: Zahlen, +
; Zahlen, *
; Bilder, overlay

; Assoziativität
; a + (b + c) = (a + b) + c
; a * (b * c) = (a * b) * c
; (overlay a (overlay b c)) = (overlay (overlay a b) c)

; Halbgruppe: Menge, binäre Operation, Assoziativität

; Halbgruppe + neutrales Element: Monoid

; Domäne: Highways mit Tieren drauf
; (list-of animal)
; brauchen:
; (: append ((list-of animal) (list-of animal) -> (list-of animal)))
; assoziativ, neutrales Element empty

(check-property
 (for-all ((l1 (list-of string))
           (l2 (list-of string))
           (l3 (list-of string)))
   (expect (append l1 (append l2 l3))
           (append (append l1 l2) l3))))

; "Receive 100GPB on 29 Jan 2021"
; "Receive 200EUR on 31 Dec 2020"
; Zero-Coupon Bond / Zero-Bond

; Ein Zero-Coupon Bond hat folgende Eigenschaften:
; - Ablaufdatum
; - Betrag
; - Währung
#;(define-record zero-coupon-bond
  make-zero-coupon-bond
  zero-coupon-bond?
  (zero-coupon-bond-expiry date)
  (zero-coupon-bond-amount real)
  (zero-coupon-bond-currency currency))

#;(define contract
    (signature
     (mixed zero-coupon-bond
            call
            put
            himalaya
            annapurna
            ...)))

(define date (signature string))
(define currency
  (signature (enum "GBP" "EUR" "USD")))

; Fragen:
; - Wieviel ist ein Vertrag wert?
; - Was für Zahlungen?
; - Wie verhält sich der Vertrag unter Marktszenarien?
; - ...
; Eine Idee ist eins der folgenden:
; - mehrere von einem Ding
; - Währung
; - Später
; - Richtung ändern
(define contract
  (signature (mixed one multiple later give both zero)))


; Eine Einheit einer Währung hat eine Eigenschaft:
; - Name der Währung ("Identifier")
(define-record one
  make-one
  one?
  (one-currency currency))

; "Mehrere von einem Ding" hat folgende Eigenschaften:
; - Wieviele
; - Welches Ding?
(define-record multiple
  make-multiple
  multiple?
  (multiple-count natural)
  #;(multiple-thing thing) ; thing entält Währung
  (multiple-contract contract))

; "Später" hat folgende Eigenschaften:
; - Wann?
; - Was?
(define-record later
  make-later
  later?
  (later-date date)
  (later-contract contract))


; "Richtung" ist eins der folgenden:
; - long
; - short
(define direction
  (signature (enum "long" "short")))


(define-record one-direction
  make-one-direction
  one-direction?
  (one-direction-direction direction)
  ; 1. Idee
  ;(one-direction-currency currency)
  (one-direction-contract contract)
  )

(define-record give
  make-give
  give?
  (give-contract contract))

; Ein Kombi-Vertrag besteht aus:
; - Vertrag
; - noch'n Vertrag
(define-record both
  make-both
  both?
  (both-contract-1 contract)
  (both-contract-2 contract))

; Neutrales Element
(define-record zero
  make-zero
  zero-contract?)

; (make-both (make-zero) c) = c
; (make-both c (make-zero)) = c
; (make-both (make-later "2020-12-31" (make-zero))
;            (make-later "2021-12-31" c))

; Zero-Coupon-Bond konstruieren
(: make-zero-coupon-bond (date natural currency -> contract))

(define make-zero-coupon-bond
  (lambda (date count currency)
    (make-later date (make-multiple count (make-one currency)))))

; Ich bekomme 1EUR jetzt
(define eur (make-one "EUR"))
; Ich bekomme 1GBP jetzt
(define gbp (make-one "GBP"))

; Ich bezahle 1GBP jetzt
(define gpb* (make-give gbp))


; Ich bekomme 100EUR jetzt
(define c1 (make-multiple 100 (make-one "EUR")))

; Ich bekomme am 31.12.2020 100EUR
(define c2 (make-later "2020-12-31" c1))

(define zcb1 (make-zero-coupon-bond "2021-01-29" 100 "GBP"))
(define zcb2 (make-zero-coupon-bond "2020-12-31" 200 "EUR"))

; Ich bezahle am 29.1.2021 100 GBP
(define zcb1* (make-give zcb1))
; Ich bekomme am 29.1.2021 100 GBP
(define zcb1** (make-give zcb1*))
; (make-give (make-give c)) = c
; (make-give (make-multiple n c)) =
;   (make-multiple n (make-give c))


(define c4 (make-both zcb1* zcb2))

; (make-later "2020-12-31"
;   (make-later "2021-12-31" c))
; (make-later "2021-12-31"
;   (make-later "2020-12-31" c))

; 2 Verträge kombinieren
#;(: make-both (contract contract -> contract))

#;(define make-both
  (lambda (contract1 contract2)
    (cond
      ((one? contract1) ...)
      ((multiple? contract1) ...)
      ((later? contract1) ...)
       (cond
         ((one? contract2)
          (if (string=? (one-currency contract1)
                        (one-currency contract2))
              (make-multiple 2 contract1)
              ???))
         ((multiple? contract2) ...)
         ((later? contract2)
          ...)))))

; Eine Zahlung hat folgende Eigenschaften:
; - Datum
; - Betrag
; - Währung
; - Richtung
(define-record payment
  make-payment
  (payment-date date)
  (payment-count natural)
  (payment-currency currency)
  (payment-direction direction))

; Zahlung hochskalieren
(: scale-payment (natural payment -> payment))

(check-expect (scale-payment 7 (make-payment "2020-01-01" 5 "EUR" "long"))
              (make-payment "2020-01-01" 35 "EUR" "long"))

(define scale-payment
  (lambda (factor payment)
    (make-payment (payment-date payment)
                  (* factor (payment-count payment))
                  (payment-currency payment)
                  (payment-direction payment))))

; Zahlung umdrehen
(: flip-payment (payment -> payment))

(check-expect (flip-payment (make-payment "2020-01-01" 5 "EUR" "long"))
              (make-payment "2020-01-01" 5 "EUR" "short"))
(check-expect (flip-payment (make-payment "2020-01-01" 5 "EUR" "short"))
              (make-payment "2020-01-01" 5 "EUR" "long"))

(define flip-payment
  (lambda (payment)
    (make-payment (payment-date payment)
                  (payment-count payment)
                  (payment-currency payment)
                  (if (string=? (payment-direction payment) "long")
                      "short"
                      "long"))))

(define-record result
  make-result
  result?
  (result-payments (list-of payment))
  (result-contract contract))

; Funktion currifizieren
; alternativ: Funktion schönfinkeln

(: curry ((%a     %b -> %c) ->
          (%a -> (%b -> %c))))

(define curry
  (lambda (f)
    (lambda (m)
      (lambda (n)
        (f m n)))))

(define date<=? string<=?)

; Bedeutung des Vertrags: Zahlungsströme bis now
(: meaning (contract date -> result))

(define meaning
  (lambda (contract now)
    (cond
      ((zero-contract? contract)
       (make-result empty
                    (make-zero)))
      ((one? contract)
       (make-result (list (make-payment now 1 (one-currency contract) "long"))
                    (make-zero)))
      ((multiple? contract)
       (define r (meaning (multiple-contract contract) now)) ; result
       ; (: map ((%a -> %b) (list-of %a) -> (list-of %b)))
       ; (result-payments r) ; dadrauf scale-payment
       (make-result (map ((curry scale-payment) (multiple-count contract))
                         (result-payments r)) ; payments
                    (make-multiple (multiple-count contract)
                                   (result-contract r)))) ; contract
      ((later? contract)
       (if (date<=? (later-date contract) now)
           (meaning (later-contract contract) now)
           (make-result empty
                        contract)))
      ((both? contract)
       (define r1 (meaning (both-contract-1 contract) now))
       (define r2 (meaning (both-contract-2 contract) now))
       (make-result (append (result-payments r1) (result-payments r2))
                    (make-both (result-contract r1) (result-contract r2))))
      ((give? contract)
       (define r (meaning (give-contract contract) now))
       (make-result (map flip-payment (result-payments r))
                    (make-give (result-contract r)))))))