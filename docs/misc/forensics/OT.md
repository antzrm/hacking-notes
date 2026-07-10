
## SCADA
SCADA systems are the "command centres" of industrial operations. They act as the bridge between human operators and the machines doing the work. Think of SCADA as the nervous system of a factory—it senses what's happening, processes that information, and sends commands to make things happen.
A SCADA system typically consists of four key components:

1. **Sensors & actuators:** These are the eyes and hands of the system. Sensors measure real-world conditions, such as temperature, pressure, position, and weight. Actuators perform physical actions—motors turn, valves open, robotic arms move. In TBFC's warehouse, sensors detect when a package is placed on the conveyor belt, and actuators control the robotic arms that load drones.
2. **PLCs (Programmable Logic Controllers):** These are the brains that execute automation logic. They read sensor data, make decisions based on programmed rules, and send commands to actuators. A PLC might decide: If the package weight matches a chocolate egg **AND** the destination is Zone 5, load it onto Drone 7. We'll explore PLCs in detail in the next task.
3. **Monitoring systems:** Visual interfaces like CCTV cameras, dashboards, and alarm panels where operators observe physical processes. TBFC's warehouse has security cameras on port 80 that show real-time footage of the packaging floor. These monitoring systems provide immediate visual feedback—you can literally watch what the automation is doing.
4. **Historians:** Databases that store operational data for later analysis. Every package loaded, every drone launched, every system change gets recorded. This historical data helps identify patterns, troubleshoot problems, and—in incident response scenarios like ours—reconstruct what an attacker did.
### Why SCADA Systems Are Targeted

Industrial control systems, such as SCADA, have become increasingly attractive targets for cybercriminals and nation-state actors. Here's why:

- They often run **legacy software** with known vulnerabilities. Many SCADA systems were installed decades ago and never updated. Security patches that exist for modern software don't exist for these ageing systems.
- **Default credentials** are commonly left unchanged. Administrators prioritise keeping systems running over changing passwords. In industrial environments, the mentality is often "if it works, don't touch it"—a recipe for security disasters.
- They're designed for **reliability, not security**. Most SCADA systems were built before cyber security was a significant concern. They were intended for closed networks that were presumed safe. Authentication, encryption, and access controls were afterthoughts at best.
- They control **physical processes**. Unlike attacking a website or stealing data, compromising SCADA systems has real-world consequences. Attackers can cause blackouts, contaminate water supplies, or—in our case—sabotage Christmas deliveries.
- They're often **connected to corporate networks**. The myth of "air-gapped" industrial systems is largely fiction. Most SCADA systems connect to business networks for reporting, remote management, and data integration. This connectivity provides attackers with entry points.
- Protocols like **Modbus lack authentication**. Many industrial protocols were designed for trusted environments. Anyone who can reach the Modbus port (502) can read and write values without proving their identity.

In early 2024, the first ICS/OT malware, [FrostyGoop](https://ciso2ciso.com/wp-content/uploads/2024/08/Dragos-Frosty-Goop-ICS-Malware-Intel-Brief.pdf), was discovered. The malware can directly interface with industrial control systems via the Modbus TCP protocol, enabling arbitrary reads and writes to device registers over TCP port 502.
## PLC
A PLC (Programmable Logic Controller) is an industrial computer designed to control machinery and processes in real-world environments. Unlike your laptop or smartphone, PLCs are purpose-built machines engineered for extreme reliability and harsh conditions.

PLCs are designed to:

- **Survive harsh environments** - They operate flawlessly in extreme temperatures, constant vibration, dust, moisture, and electromagnetic interference. A PLC controlling warehouse robotics might endure freezing temperatures in winter storage areas and scorching heat near packaging machinery.
- **Run continuously without failure** - PLCs operate 24/7 for years, sometimes decades, without rebooting. Industrial facilities can't afford downtime for software updates or system restarts. When a PLC starts running, it's expected to keep running indefinitely.
- **Execute control logic in real-time** - PLCs respond to sensor inputs within milliseconds. When a package reaches the end of a conveyor belt, the PLC must instantly activate the robotic arm to catch it. These timing requirements are critical for safety and efficiency.
- **Interface directly with physical hardware** - PLCs connect directly to sensors (measuring temperature, pressure, position, weight) and actuators (motors, valves, switches, robotic arms). They speak the electrical language of industrial machinery.
## Modbus
Modbus is the communication protocol that industrial devices use to talk to each other. Created in 1979 by Modicon (now Schneider Electric), it's one of the oldest and most widely deployed industrial protocols in the world. Its longevity isn't due to sophisticated features—quite the opposite. Modbus succeeded because it's simple, reliable, and works with almost any device.

Think of Modbus as a basic request-response conversation:

- **Client** (your computer): "PLC, what's the current value of register 0?"
- **Server** (the PLC): "Register 0 currently holds the value 1."

This simplicity makes Modbus easy to implement and debug, but it also means security was never a consideration. There's no authentication, no encryption, no authorisation checking. Anyone who can reach the Modbus port can read or write any value. It's the equivalent of leaving your house unlocked with a sign saying "Come in, everything's accessible!"

## Modbus Data Types

Modbus organises data into four distinct types, each serving a specific purpose in industrial automation:

|Type|Purpose|Values|Example Use Cases|
|---|---|---|---|
|**Coils**|Digital outputs (on/off)|0 or 1|Motor running? Valve open? Alarm active?|
|**Discrete Inputs**|Digital inputs (on/off)|0 or 1|Button pressed? Door closed? Sensor triggered?|
|**Holding Registers**|Analogue outputs (numbers)|0-65535|Temperature setpoint, motor speed, zone selection|
|**Input Registers**|Analogue inputs (numbers)|0-65535|Current temperature, pressure reading, flow rate|

The distinction between inputs and outputs is important. **Coils** and **Holding Registers** are writable—you can change their values to control the system. **Discrete Inputs** and **Input Registers** are read-only—they reflect sensor measurements that you observe but cannot directly modify.
### Modbus Addressing

Each data point in Modbus has a unique **address**—think of it like a house number on a street. When you want to read or write a specific value, you reference it by its address number.

**Critical detail:** Modbus addresses start at 0, not 1. This zero-indexing catches many beginners off guard. When documentation mentions "Register 0," it literally means the first register, not the second.
### Modbus TCP vs Serial Modbus

Originally, Modbus operated over serial connections using RS-232 or RS-485 cables. Devices were physically connected in a network, and this physical isolation provided a degree of security—you needed physical access to the wiring to intercept or inject commands.

Modern industrial systems use **Modbus TCP**, which encapsulates the Modbus protocol inside standard TCP/IP network packets. Modbus TCP servers listen on **port 502** by default.

This network connectivity brings enormous benefits—remote monitoring, easier integration with business systems, and centralised management. But it also exposes these historically isolated systems to network-based attacks.
### The Security Problem

Modbus has no built-in security mechanisms:

- **No authentication:** The protocol doesn't verify who's making requests. Any client can connect and issue commands.
- **No encryption:** All communication happens in plaintext. Anyone monitoring network traffic can see exactly what values are being read or written.
- **No authorisation:** There's no concept of permissions. If you can connect, you can read and write anything.
- **No integrity checking:** Beyond basic checksums for transmission errors, there's no cryptographic verification that commands haven't been tampered with.

Modern security solutions exist—VPNs, firewalls, Modbus security gateways—but they're add-ons, not part of the protocol itself. Many industrial facilities haven't implemented these protections, either due to cost concerns, compatibility issues with legacy equipment, or a simple lack of awareness.
## Practical
- Scan ports like 80, 502
```python
# 1. Install pymodbus
pip3 install pymodbus==3.6.8

# 2. Establish Connection
python3
Python 3.10.12 (main, Nov 20 2023, 15:14:05)
Type "help", "copyright", "credits" or "license" for more information.
>>> from pymodbus.client import ModbusTcpClient
>>> 
>>> # Connect to the PLC on port 502
>>> client = ModbusTcpClient('10.66.191.205', port=502)
>>> 
>>> # Establish connection
>>> if client.connect():
...     print("Connected to PLC successfully")
... else:
...     print("Connection failed")
... 
Connected to PLC successfully
>>>

# 3. Reading Holding Registers
>>> # Read holding register 0 (Package Type)
>>> result = client.read_holding_registers(address=0, count=1, slave=1)
>>> 
>>> if not result.isError():
...     package_type = result.registers[0]
...     print(f"HR0 (Package Type): {package_type}")
...     if package_type == 0:
...         print("  Christmas Presents")
...     elif package_type == 1:
...         print("  Chocolate Eggs")
...     elif package_type == 2:
...         print("  Easter Baskets")
... 
HR0 (Package Type): 1
  Chocolate Eggs
>>>

# 4. Reading Coils
>>> # Read coil 10 (Inventory Verification)
>>> result = client.read_coils(address=10, count=1, slave=1)
>>> 
>>> if not result.isError():
...     verification = result.bits[0]
...     print(f"C10 (Inventory Verification): {verification}")
...     if not verification:
...         print("  DISABLED - System not checking stock")
... 
C10 (Inventory Verification): False
  DISABLED - System not checking stock
>>>
```
### Recoinassance Script
```python
#!/usr/bin/env python3
from pymodbus.client import ModbusTcpClient

PLC_IP = "10.66.191.205"
PORT = 502
UNIT_ID = 1

# Connect to PLC
client = ModbusTcpClient(PLC_IP, port=PORT)

if not client.connect():
    print("Failed to connect to PLC")
    exit(1)

print("=" * 60)
print("TBFC Drone System - Reconnaissance Report")
print("=" * 60)
print()

# Read holding registers
print("HOLDING REGISTERS:")
print("-" * 60)

registers = client.read_holding_registers(address=0, count=5, slave=UNIT_ID)
if not registers.isError():
    hr0, hr1, hr2, hr3, hr4 = registers.registers
    
    print(f"HR0 (Package Type): {hr0}")
    print(f"  0=Christmas, 1=Eggs, 2=Baskets")
    print()
    
    print(f"HR1 (Delivery Zone): {hr1}")
    print(f"  1-9=Normal zones, 10=Ocean dump")
    print()
    
    print(f"HR4 (System Signature): {hr4}")
    if hr4 == 666:
        print(f"  WARNING: Eggsploit signature detected")
    print()

# Read coils
print("COILS (Boolean Flags):")
print("-" * 60)

coils = client.read_coils(address=10, count=6, slave=UNIT_ID)
if not coils.isError():
    c10, c11, c12, c13, c14, c15 = coils.bits[:6]
    
    print(f"C10 (Inventory Verification): {c10}")
    print(f"  Should be True")
    print()
    
    print(f"C11 (Protection/Override): {c11}")
    if c11:
        print(f"  ACTIVE - System monitoring for changes")
    print()
    
    print(f"C12 (Emergency Dump): {c12}")
    if c12:
        print(f"  CRITICAL: Dump protocol active")
    print()
    
    print(f"C13 (Audit Logging): {c13}")
    print(f"  Should be True")
    print()
    
    print(f"C14 (Christmas Restored): {c14}")
    print(f"  Auto-set when system is fixed")
    print()
    
    print(f"C15 (Self-Destruct Armed): {c15}")
    if c15:
        print(f"  DANGER: Countdown active")
    print()

print("=" * 60)
print("THREAT ASSESSMENT:")
print("=" * 60)

if hr4 == 666:
    print("Eggsploit framework detected")
if c11:
    print("Protection mechanism active - trap is set")
if hr0 == 1:
    print("Package type forced to eggs")
if not c10:
    print("Inventory verification disabled")
if not c13:
    print("Audit logging disabled")

print()
print("REMEDIATION REQUIRED")
print("=" * 60)

client.close()
```
