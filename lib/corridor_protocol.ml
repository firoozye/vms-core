type corridor = {
  mutable price : int;
  mutable half_width : int;
  mutable variance : int;
}

let create () = {
  price = 0;
  half_width = 0;
  variance = 0;
}

let update c p hw v =
  c.price <- p;
  c.half_width <- hw;
  c.variance <- v
