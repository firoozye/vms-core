type quote = {
  price : int;
  size : int;
}

let calculate_mid bid ask =
  (bid + ask) / 2
