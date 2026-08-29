open Vms_core_subset.Risk_gate

let assert_equal expected actual msg =
  if expected <> actual then
    failwith (Printf.sprintf "%s: expected %d, got %d" msg expected actual)

let () =
  let params = { max_position = 100; quote_size = 10 } in
  assert_equal 10 (check_order_size 90 10 params) "Should allow size 10 at pos 90";
  assert_equal 0 (check_order_size 95 10 params) "Should reject size 10 at pos 95 (violates max 100)";
  assert_equal (-10) (check_order_size (-90) (-10) params) "Should allow short size -10 at pos -90";
  assert_equal 0 (check_order_size (-95) (-10) params) "Should reject short size -10 at pos -95 (violates max 100)";
  
  let sizes = [10; 20; 30; 50; (-20)] in
  let final_pos = process_orders 0 sizes params in
  assert_equal 40 final_pos "process_orders failed (should cap position at 60, then drop by 20 to 40)";
  
  print_endline "All tests passed successfully!"
