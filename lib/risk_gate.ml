type params = {
  max_position : int;
  quote_size : int;
}

let check_order_size position size params =
  if abs (position + size) <= params.max_position then
    size
  else
    0

let rec process_orders position sizes params =
  match sizes with
  | [] -> position
  | sz :: rest ->
      let next_pos = position + check_order_size position sz params in
      process_orders next_pos rest params
