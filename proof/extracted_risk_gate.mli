
type comparison =
| Eq
| Lt
| Gt

val compOpp : comparison -> comparison

type positive =
| XI of positive
| XO of positive
| XH



module Pos :
 sig
  val succ : positive -> positive

  val add : positive -> positive -> positive

  val add_carry : positive -> positive -> positive

  val pred_double : positive -> positive

  val compare_cont : comparison -> positive -> positive -> comparison

  val compare : positive -> positive -> comparison
 end

module Z :
 sig
  val double : int -> int

  val succ_double : int -> int

  val pred_double : int -> int

  val pos_sub : positive -> positive -> int

  val add : int -> int -> int

  val compare : int -> int -> comparison

  val leb : int -> int -> bool

  val abs : int -> int
 end

module Params :
 sig
  type t = { max_position : int; quote_size : int }

  val max_position : t -> int
 end

val check_order_size : int -> int -> Params.t -> int

val process_orders : int -> int list -> Params.t -> int
