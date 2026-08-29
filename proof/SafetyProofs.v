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

Require Import List.
Import ListNotations.

Fixpoint process_orders (pos : Z) (sizes : list Z) (params : Params.t) : Z :=
  match sizes with
  | [] => pos
  | sz :: rest =>
      let next_pos := pos + (check_order_size pos sz params) in
      process_orders next_pos rest params
  end.

Theorem process_orders_bounds_safe : forall (sizes : list Z) (pos : Z) (params : Params.t),
  Z.abs pos <= Params.max_position params ->
  Z.abs (process_orders pos sizes params) <= Params.max_position params.
Proof.
  induction sizes as [| sz rest IH].
  - simpl. intros pos params Hinv. exact Hinv.
  - simpl. intros pos params Hinv.
    apply IH.
    apply check_order_size_bounds_safe.
    exact Hinv.
Qed.
