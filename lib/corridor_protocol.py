import struct
from enum import IntEnum

class ExecutionPolicy(IntEnum):
    AVELLANEDA_STOIKOV = 0
    CARTEA_JAIMUNGAL = 1
    ALMGREN_CHRISS = 2
    TWAP = 3
    VWAP = 4
    DIRECT_LIQUIDATION = 5
    PROPRIETARY_MODEL = 6

def pack_corridor(log_w: float, half_width_log: float, variance: float, timestamp_ns: int, policy: ExecutionPolicy, param_int: int, param_float: float) -> bytes:
    """
    Packs the corridor protocol state into a 48-byte binary buffer.
    
    Layout:
      - 0..7: log_w (double)
      - 8..15: half_width_log (double)
      - 16..23: variance (double)
      - 24..31: timestamp_ns (int64)
      - 32..35: policy_tag (int32)
      - 36..39: param_int (int32)
      - 40..47: param_float (double)
    """
    return struct.pack('<dddqiiid', log_w, half_width_log, variance, timestamp_ns, int(policy), param_int, 0, param_float)

def unpack_corridor(buf: bytes) -> tuple:
    """
    Unpacks a 48-byte binary buffer into python types:
    (log_w, half_width_log, variance, timestamp_ns, policy, param_int, param_float)
    """
    log_w, half_width_log, variance, timestamp_ns, policy_val, param_int, _, param_float = struct.unpack('<dddqiiid', buf[:48])
    return (log_w, half_width_log, variance, timestamp_ns, ExecutionPolicy(policy_val), param_int, param_float)
