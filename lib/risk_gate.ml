type params = {
  max_position : int;
  quote_size : int;
}

let check_order_size position size params =
  if abs (position + size) <= params.max_position then
    size
  else
    0
