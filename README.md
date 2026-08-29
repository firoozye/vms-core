# VMS Core Subset

This repository contains a self-contained, low-latency core subset of the **Verified Market Simulator (VMS)** matching engine and its associated mathematical proofs of correctness.
This is a subset of the core work by begun as a project with https://github.com/alunity, https://github.com/Maksymilian-Sieklinski, https://github.com/dachenzo.


## Structure

* **`lib/`**: Standalone OCaml modules containing:
  * `corridor_protocol`: Lock-free atomic shared-memory state sharing.
  * `risk_gate`: Order size risk gates enforcing strict position limits.
  * `mm_utils`: Slicing/pricing utility helpers.
* **`proof/`**: Mathematical specification and inductive correctness proofs in Rocq (Coq).
* **`test/`**: Pure OCaml unit tests validating boundary quoter execution.

## Building the OCaml Library

To build the project and execute the tests, ensure you have OCaml (5.x recommended) and Dune installed:

```bash
# Build the library
dune build

# Run the quoter boundary tests
dune exec test/test_quoter.exe
```

## Verifying the Proofs

The correctness proofs are written in Rocq. To check the position boundary enforcement proof:

```bash
cd proof/
coqc RiskGate.v
coqc SafetyProofs.v
```

The output of `coqc SafetyProofs.v` should complete silently without errors, proving that the risk gate is mathematically guaranteed to prevent position limit violations under any inputs.

## Accessing Free LOBSTER Market Data

To run high-throughput backtesting simulations, the engine ingests binary market feeds. You can obtain free, high-density Level 3 LOBSTER data samples directly from the official LOBSTER data catalog:

1. Visit [LOBSTER Data Samples](https://lobsterdata.com/info/DataSamples.php).
2. Download the free sample CSV files containing the `message` and `orderbook` logs (e.g., for AAPL or AMZN).
3. Use the converter utility script provided in the main VMS toolchain (`scripts/csv_to_tvms.py`) to pack the LOBSTER CSV files into the high-performance `.tvms` binary format:
   ```bash
   python3 scripts/csv_to_tvms.py --messages message.csv --orderbook orderbook.csv --output data.tvms
   ```

A lightweight synthetic mock data file is built directly into our test suite to allow you to compile, build, and verify simulator loops locally without downloading external files.
