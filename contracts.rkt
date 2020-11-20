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
  (signature (mixed one multiple later give)))


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