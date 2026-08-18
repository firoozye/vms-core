Require Import ZArith.
Require Import RiskGate.
Require Import Lia.

Open Scope Z_scope.

Theorem check_order_size_bounds_safe : forall (pos size: Z) (params: Params.t),
  Z.abs pos <= Params.max_position params ->
  Z.abs (pos + (check_order_size pos size params)) <= Params.max_position params.
Proof.
  intros pos size params Hinv.
  unfold check_order_size.
  (* Destruct the boolean comparison *)
  destruct (Z.leb (Z.abs (pos + size)) (Params.max_position params)) eqn:Hleb.
  - apply Z.leb_le in Hleb.
    exact Hleb.
  - simpl.
    rewrite Z.add_0_r.
    exact Hinv.
Qed.
