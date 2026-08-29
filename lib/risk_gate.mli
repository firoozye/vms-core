type params = {
  max_position : int;
  quote_size : int;
}

val check_order_size : int -> int -> params -> int
val process_orders : int -> int list -> params -> int
