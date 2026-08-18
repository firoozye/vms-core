type corridor = {
  mutable price : int;
  mutable half_width : int;
  mutable variance : int;
}

val create : unit -> corridor
val update : corridor -> int -> int -> int -> unit
