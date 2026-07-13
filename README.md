# SystemVerilog Clocking Block Verification Environment

A **SystemVerilog class-based verification environment** demonstrating the use of **clocking blocks**, **virtual interfaces**, **mailboxes**, and **object-oriented programming (OOP)** concepts. The project verifies a simple **3-bit Full Adder** while emphasizing reusable verification architecture and race-free communication between the testbench and DUT.

---

## Features

- Class-based verification environment
- Clocking block for synchronized signal driving and sampling
- Virtual interface based driver
- Mailbox-based communication between Generator and Driver
- Randomized transaction generation
- Transaction copying to prevent handle sharing
- Inheritance and polymorphism using packet classes
- Demonstration of `post_randomize()`
- Modular and reusable verification architecture

---

## Project Structure

```
.
├── README.md
├── clcoking_block.sv
├── clcoking_block_driver.sv
├── clcoking_block_env.sv
├── clcoking_block_generator.sv
└── clcoking_block_packets.sv
```

### File Description

| File | Description |
|------|-------------|
| `clcoking_block.sv` | Contains the Full Adder DUT, Interface, Program Testbench, and Top module |
| `clcoking_block_driver.sv` | Driver that retrieves transactions from the mailbox and drives the DUT using the clocking block |
| `clcoking_block_generator.sv` | Generates randomized transactions |
| `clcoking_block_env.sv` | Builds and connects all verification components |
| `clcoking_block_packets.sv` | Defines transaction classes (`pkt_in`, `bad_pkt_in`, and `pkt_out`) |

---

# Verification Architecture

```
                      +--------------------+
                      |     Generator      |
                      +--------------------+
                                |
                                |
                           Mailbox (pkt_in)
                                |
                                |
                                V
                      +--------------------+
                      |       Driver       |
                      +--------------------+
                                |
                     Virtual Interface
                      (Clocking Block)
                                |
                                |
                                V
                      +--------------------+
                      |        DUT         |
                      |    Full Adder      |
                      +--------------------+
                                |
                                |
                             Outputs
```

---

# DUT

The DUT is a simple Full Adder.

### Inputs

| Signal | Width |
|---------|------:|
| a | 3 bits |
| b | 3 bits |
| c | 1 bit |

### Outputs

| Signal | Width |
|---------|------:|
| sum | 4 bits |
| carry | 1 bit |

Operation:

```
sum = a + b + c
carry = sum[3]
```

---

# Interface

The interface contains

- DUT signals
- Clock
- Clocking Block
- Modports

```systemverilog
clocking cb @(posedge clk);

output a;
output b;
output c;

input sum;
input carry;

endclocking
```

Clocking blocks provide synchronized communication between the testbench and DUT, eliminating race conditions.

---

# Verification Components

## Generator

Responsibilities

- Creates randomized packets
- Calls `randomize()`
- Computes expected outputs
- Sends copied transactions to the mailbox

Main functions

- `run()`

---

## Driver

Responsibilities

- Retrieves transactions from the mailbox
- Waits on the clocking block
- Drives DUT inputs using the virtual interface

Main functions

- `send()`
- `run()`

---

## Environment

The environment is responsible for

- Creating the generator and driver
- Connecting them through a mailbox
- Passing the virtual interface
- Running both components concurrently

```systemverilog
fork
    gen.run(n);
    drv.run(n);
join
```

---

# Packet Classes

## pkt_in

Transaction class containing

- packet id
- packet name
- inputs (`a`, `b`, `c`)
- expected `sum`
- expected `carry`

Functions

- `copy()`
- `display()`
- `summing()`
- `post_randomize()`

---

## bad_pkt_in

Derived transaction class

```systemverilog
class bad_pkt_in extends pkt_in;
```

Features

- Demonstrates inheritance
- Overrides virtual methods
- Can intentionally generate incorrect expected outputs for negative testing

---

## pkt_out

Stores DUT outputs

Members

- sum
- carry

---

# OOP Concepts Demonstrated

## Inheritance

```systemverilog
class bad_pkt_in extends pkt_in;
```

---

## Virtual Functions

The following functions are overridden by derived classes

- `display()`
- `copy()`
- `summing()`

---

## Polymorphism

The verification environment can use either

- `pkt_in`
- `bad_pkt_in`

without changing the driver implementation.

---

## Object Copying

Transactions are copied before being placed into the mailbox

```systemverilog
gen_to_drive.put(pkt.copy());
```

This prevents multiple mailbox entries from pointing to the same object handle.

---

# Randomization Flow

```
randomize()

      |

Constraint Solver

      |

post_randomize()

      |

summing()

      |

display()
```

`post_randomize()` automatically

- Assigns packet ID
- Generates packet name
- Calculates expected outputs
- Displays the transaction

---

# Mailbox Communication

Generator

```systemverilog
gen_to_drive.put(pkt.copy());
```

Driver

```systemverilog
gen_to_drive.get(pkt);
```

Mailboxes provide synchronized communication between concurrently executing verification components.

---

# Clocking Block Synchronization

Driver drives signals through the clocking block

```systemverilog
intff.cb.a <= pkt.a;
intff.cb.b <= pkt.b;
intff.cb.c <= pkt.c;
```

Synchronization

```systemverilog
@intff.cb;
```

This ensures race-free communication between the testbench and DUT.

---

# Simulation Flow

```
Simulation Starts
        │
        ▼
Environment Build
        │
        ▼
Generator Randomizes Packet
        │
        ▼
Transaction Copied
        │
        ▼
Placed into Mailbox
        │
        ▼
Driver Retrieves Packet
        │
        ▼
Driver Waits for Clock Edge
        │
        ▼
Inputs Driven to DUT
        │
        ▼
DUT Computes Output
        │
        ▼
Results Displayed
        │
        ▼
Repeat
```

---

# SystemVerilog Concepts Covered

- Interfaces
- Modports
- Clocking Blocks
- Programs
- Virtual Interfaces
- Mailboxes
- Packages
- Classes
- Inheritance
- Polymorphism
- Virtual Functions
- Randomization
- `post_randomize()`
- Transaction Copying
- Concurrent Processes (`fork...join`)
- Object-Oriented Verification

---

# Expected Output

```
pkt_1
a = 3
b = 2
c = 1
sum = 6
carry = 0

Received from TB:
a = 3
b = 2
c = 1

Sent by DUT:
sum = 6
carry = 0
```

*(Values will vary due to randomization.)*

---

# Future Improvements

- Monitor
- Scoreboard
- Functional Coverage
- Assertions (SVA)
- Coverage-driven Verification
- Multiple Drivers
- Multiple Agents
- Constrained Random Testing
- Migration to UVM

---

# Tools Used

- **SystemVerilog**
- **QuestaSim / ModelSim**
- **Object-Oriented Verification**

---

# Learning Outcomes

This project demonstrates how to:

- Build a reusable class-based verification environment
- Use clocking blocks for race-free synchronization
- Connect verification components using mailboxes
- Use virtual interfaces to drive DUT signals
- Apply inheritance and polymorphism in verification
- Generate and copy randomized transactions
- Create modular verification components that can be extended to more complex designs

---

## Author

**Raj Pandey**

B.Tech in Electronics and Communication Engineering

**Areas of Interest**

- RTL Design
- Functional Verification
- Digital IC Design
- SystemVerilog & UVM
- VLSI Design and Verification
