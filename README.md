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

## Verifying the Proofs & Compiling to OCaml

The correctness proofs are written in Rocq. To check the proofs and extract OCaml code:

```bash
cd proof/
# Verify core components
coqc RiskGate.v
coqc SafetyProofs.v

# Extract Coq proof specifications to OCaml code
coqc Extraction.v
```

The output of `coqc SafetyProofs.v` should complete silently without errors, proving that the risk gate is mathematically guaranteed to prevent position limit violations. Running `coqc Extraction.v` will dynamically generate a clean OCaml file `extracted_risk_gate.ml` that maps precisely to our verified Coq model.

## Running the End-to-End Python-OCaml Pipeline

The simulator relies on a Python preprocessing stage to pack raw CSV feeds into high-speed binary formats, and a lock-free corridor layout for communication:

1. **Python Shared Memory Corridor**: Look at `lib/corridor_protocol.py`, which mirrors the memory-mapped layout in `lib/corridor_protocol.ml` to parse states.
2. **Convert CSV data**: Run our packing script on the mock LOBSTER data files included in the test directory:
   ```bash
   python3 scripts/csv_to_tvms.py test/message_mock.csv test/orderbook_mock.csv data.tvms
   ```
   This generates `data.tvms`, a packed binary file that the OCaml backtester can map directly into memory.

## Accessing Real LOBSTER Market Data

To run full simulations, you can obtain free, high-density Level 3 LOBSTER data samples directly from the official LOBSTER catalog:

1. Visit [LOBSTER Data Samples](https://lobsterdata.com/info/DataSamples.php).
2. Download the free sample CSV files containing the `message` and `orderbook` logs (e.g., for AAPL or AMZN).
3. Convert them using the same python script:
   ```bash
   python3 scripts/csv_to_tvms.py message.csv orderbook.csv data.tvms
   ```
