(* Translated representation of RiskGate *)
Require Import ZArith.
Open Scope Z_scope.

Module Params.
  Record t : Type := {
    max_position : Z;
    quote_size : Z;
  }.
End Params.

Definition check_order_size (pos size: Z) (params: Params.t) : Z :=
  if Z.leb (Z.abs (pos + size)) (Params.max_position params) then
    size
  else
    0.
