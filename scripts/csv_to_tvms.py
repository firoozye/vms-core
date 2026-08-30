import struct
import sys
import csv

def csv_to_tvms(message_csv, orderbook_csv, output_tvms):
    # Pack a simple TVMS binary file
    # We write 4-byte magic "TVMS" + version 1, midnight epoch 0, 0 asks, 0 bids, then messages
    with open(output_tvms, "wb") as f:
        f.write(b"TVMS\x01")
        f.write(struct.pack("<Q", 0)) # Midnight epoch
        f.write(struct.pack("<I", 0)) # 0 Asks
        f.write(struct.pack("<I", 0)) # 0 Bids
        
        # Read LOBSTER CSV messages
        with open(message_csv, "r") as mc:
            reader = csv.reader(mc)
            for row in reader:
                if not row:
                    continue
                # LOBSTER cols: time (seconds since midnight), event_type, order_id, size, price, direction
                time_sec = float(row[0])
                event_type = int(row[1])
                order_id = int(row[2])
                size = int(row[3])
                price = int(row[4])
                direction = int(row[5])
                
                # Convert time to nanoseconds timestamp
                time_ns = int(time_sec * 1e9)
                
                # Pack message: event_type(B), direction(b), time(Q), id(q), size(Q), price(q)
                f.write(struct.pack("<BbQqQq", event_type, direction, time_ns, order_id, size, price))
    print(f"Successfully converted {message_csv} to {output_tvms}")

if __name__ == "__main__":
    if len(sys.argv) < 4:
        print("Usage: python3 csv_to_tvms.py <message.csv> <orderbook.csv> <output.tvms>")
    else:
        csv_to_tvms(sys.argv[1], sys.argv[2], sys.argv[3])
