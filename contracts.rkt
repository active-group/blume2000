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
(define-record zero-coupon-bond
  make-zero-coupon-bond
  zero-coupon-bond?
  (zero-coupon-bond-expiry date)
  (zero-coupon-bond-amount real)
  (zero-coupon-bond-currency currency))

(define date (signature string))
(define currency
  (signature (enum "GBP" "EUR" "USD")))

(define zcb1 (make-zero-coupon-bond "2021-01-29" 100 "GBP"))
(define zcb2 (make-zero-coupon-bond "2020-12-31" 200 "EUR"))

; Eine Idee ist eins der folgenden:
; - mehrere von einem Ding
; - Währung
; - Später
(define contract
  (signature (mixed one multiple)))

; Eine Einheit einer Währung hat eine Eigenschaft:
; - Name der Währung ("Identifier")
(define-record one
  make-one
  one?
  (one-currency currency))

(define eur (make-one "EUR"))
(define gbp (make-one "GBP"))

; "Mehrere von einem Ding" hat folgende Eigenschaften:
; - Wieviele
; - Welches Ding?
(define-record multiple
  make-multiple
  multiple?
  (multiple-count natural)
  (multiple-contract contract))

; 100EUR jetzt
(define c1 (make-multiple 100 (make-one "EUR")))



