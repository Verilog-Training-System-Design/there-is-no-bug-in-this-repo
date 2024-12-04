# there-is-no-bug-in-this-repo

## TODO task

### src

- [x] CSR related
  - [x] changing csr registers when calling CSR instruction
  - [x] 11/25 changing csr registers when return from interrupt
  - [x] changing csr registers when interrupt is taken
  - [x] CSR output data
  - [x] 11/21 CPU action when interrupt happen
  - [x] 11/21 CPU action when interrupt return
  - [x] 11/21 trap in the cpu
  - [x] 11/21 connect each line in cpu
- [x] DRAM_wrapper
  - [x] 11/23 FSM stage design
  - [x] 11/24 what to do in each stage
  - [x] 11/24 delay clock
  - [x] 11/25 input address assign
  - [x] 11/25 when reading/writing continous data how address increase
- [x] ROM_wrapper
- [x] WDT_wrapper
  - [x] Input signal for WDT
  - [x] Slave wrapper two version integration
- [x] WDT implementation
  - [x] 11/20 Clock problem - one bit
  - [ ] Clock domain - mult bit (11/23)
- [x] DMA_wrapper
  - [x] 3 submudule wire connect
- [x] DMA implementation
  - [x] Slave Part (need to double check)
  - [x] Master Part (port integration)
  - [x] DMA Module
    - [x] Inner FSM
    - [x] register for data store
    - [x] data len to cal. data transfer
- [x] ROM implementation
- [ ] top module
  - [x] 11/25 DRAM wire connect
  - [ ] ROM wire connect
  - [x] 11/25 DMA wire connect
  - [ ] AXI wire connect
    - [ ] ROM write channels wire connect
- [ ] AXI modified
  - [x] Decoder address extension
  - [x] 11/21 Arbiter lock extension
  - [x] 11/21 read data channel lock extension
  - [ ] write data channel lock extension
  - [x] 11/22 write response channel lock extension
- [x] task finished

#### others

- [x] remove useless comment

### sim

- [ ] prog0
  - [x] 11/22 boot.c
- [ ] prog1
  - [ ] boot.c
  - [ ] main.c
- [ ] prog2
  - [ ] main.c
- [ ] prog3

## Message boards

11/18 : Add task breakdown items.

## Problem encountered

|stage|problem description|
|-----|-------------------|
|fixed| 11/20 : cpu csr stall condition not decided yet.|
|fixed| 11/22 : DRAM_wrapper stage design.|
