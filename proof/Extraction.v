Require Import ZArith.
Require Import RiskGate.
Require Import SafetyProofs.
Require Extraction.
Extraction Language OCaml.

(* Map Coq types to native OCaml types *)
Extract Inductive list => "list" [ "[]" "(::)" ].
Extract Inductive bool => "bool" [ "true" "false" ].
Extract Inductive option => "option" [ "Some" "None" ].

(* Map arbitrary-precision integers Z to OCaml native integers *)
Extract Inductive Z => "int" [ "0" "" "" ] "(*)".

(* Extract the verified risk functions *)
Extraction "extracted_risk_gate.ml" check_order_size process_orders.
