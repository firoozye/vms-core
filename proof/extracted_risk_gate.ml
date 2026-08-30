
type comparison =
| Eq
| Lt
| Gt

(** val compOpp : comparison -> comparison **)

let compOpp = function
| Eq -> Eq
| Lt -> Gt
| Gt -> Lt

type positive =
| XI of positive
| XO of positive
| XH



module Pos =
 struct
  (** val succ : positive -> positive **)

  let rec succ = function
  | XI p -> XO (succ p)
  | XO p -> XI p
  | XH -> XO XH

  (** val add : positive -> positive -> positive **)

  let rec add x y =
    match x with
    | XI p ->
      (match y with
       | XI q -> XO (add_carry p q)
       | XO q -> XI (add p q)
       | XH -> XO (succ p))
    | XO p ->
      (match y with
       | XI q -> XI (add p q)
       | XO q -> XO (add p q)
       | XH -> XI p)
    | XH -> (match y with
             | XI q -> XO (succ q)
             | XO q -> XI q
             | XH -> XO XH)

  (** val add_carry : positive -> positive -> positive **)

  and add_carry x y =
    match x with
    | XI p ->
      (match y with
       | XI q -> XI (add_carry p q)
       | XO q -> XO (add_carry p q)
       | XH -> XI (succ p))
    | XO p ->
      (match y with
       | XI q -> XO (add_carry p q)
       | XO q -> XI (add p q)
       | XH -> XO (succ p))
    | XH ->
      (match y with
       | XI q -> XI (succ q)
       | XO q -> XO (succ q)
       | XH -> XI XH)

  (** val pred_double : positive -> positive **)

  let rec pred_double = function
  | XI p -> XI (XO p)
  | XO p -> XI (pred_double p)
  | XH -> XH

  (** val compare_cont : comparison -> positive -> positive -> comparison **)

  let rec compare_cont r x y =
    match x with
    | XI p ->
      (match y with
       | XI q -> compare_cont r p q
       | XO q -> compare_cont Gt p q
       | XH -> Gt)
    | XO p ->
      (match y with
       | XI q -> compare_cont Lt p q
       | XO q -> compare_cont r p q
       | XH -> Gt)
    | XH -> (match y with
             | XH -> r
             | _ -> Lt)

  (** val compare : positive -> positive -> comparison **)

  let compare =
    compare_cont Eq
 end

module Z =
 struct
  (** val double : int -> int **)

  let double x =
    (*)
      (fun _ -> 0)
      (fun p -> (XO p))
      (fun p -> (XO p))
      x

  (** val succ_double : int -> int **)

  let succ_double x =
    (*)
      (fun _ -> XH)
      (fun p -> (XI p))
      (fun p -> (Pos.pred_double p))
      x

  (** val pred_double : int -> int **)

  let pred_double x =
    (*)
      (fun _ -> XH)
      (fun p -> (Pos.pred_double p))
      (fun p -> (XI p))
      x

  (** val pos_sub : positive -> positive -> int **)

  let rec pos_sub x y =
    match x with
    | XI p ->
      (match y with
       | XI q -> double (pos_sub p q)
       | XO q -> succ_double (pos_sub p q)
       | XH -> (XO p))
    | XO p ->
      (match y with
       | XI q -> pred_double (pos_sub p q)
       | XO q -> double (pos_sub p q)
       | XH -> (Pos.pred_double p))
    | XH ->
      (match y with
       | XI q -> (XO q)
       | XO q -> (Pos.pred_double q)
       | XH -> 0)

  (** val add : int -> int -> int **)

  let add x y =
    (*)
      (fun _ -> y)
      (fun x' ->
      (*)
        (fun _ -> x)
        (fun y' -> (Pos.add x' y'))
        (fun y' -> pos_sub x' y')
        y)
      (fun x' ->
      (*)
        (fun _ -> x)
        (fun y' -> pos_sub y' x')
        (fun y' -> (Pos.add x' y'))
        y)
      x

  (** val compare : int -> int -> comparison **)

  let compare x y =
    (*)
      (fun _ -> (*)
                  (fun _ -> Eq)
                  (fun _ -> Lt)
                  (fun _ -> Gt)
                  y)
      (fun x' ->
      (*)
        (fun _ -> Gt)
        (fun y' -> Pos.compare x' y')
        (fun _ -> Gt)
        y)
      (fun x' ->
      (*)
        (fun _ -> Lt)
        (fun _ -> Lt)
        (fun y' -> compOpp (Pos.compare x' y'))
        y)
      x

  (** val leb : int -> int -> bool **)

  let leb x y =
    match compare x y with
    | Gt -> false
    | _ -> true

  (** val abs : int -> int **)

  let abs z0 =
    (*)
      (fun _ -> 0)
      (fun p -> p)
      (fun p -> p)
      z0
 end

module Params =
 struct
  type t = { max_position : int; quote_size : int }

  (** val max_position : t -> int **)

  let max_position t0 =
    t0.max_position
 end

(** val check_order_size : int -> int -> Params.t -> int **)

let check_order_size pos size params =
  if Z.leb (Z.abs (Z.add pos size)) params.Params.max_position
  then size
  else 0

(** val process_orders : int -> int list -> Params.t -> int **)

let rec process_orders pos sizes params =
  match sizes with
  | [] -> pos
  | sz::rest ->
    let next_pos = Z.add pos (check_order_size pos sz params) in
    process_orders next_pos rest params
