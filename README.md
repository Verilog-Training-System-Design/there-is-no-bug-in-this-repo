# there-is-no-bug-in-this-repo

## TODO task

### src

- [ ] CSR related
  - [x] changing csr registers when calling CSR instruction
  - [ ] changing csr registers when return from interrupt
  - [x] changing csr registers when interrupt is taken
  - [x] CSR output data
  - [x] 11/21 CPU action when interrupt happen
  - [x] 11/21 CPU action when interrupt return
  - [x] 11/21 trap in the cpu
  - [x] 11/21 connect each line in cpu
- [ ] DRAM_wrapper
- [ ] ROM_wrapper
- [ ] WDT_wrapper
  - [x] Input signal for WDT
  - [ ] Slave wrapper two version integration
- [ ] WDT implementation
  - [x] 11/20 Clock problem - one bit
  - [ ] 11/21 Clock domain - mult bit
- [ ] DMA_wrapper
- [ ] DMA implementation
  - [ ] 11/21 Master Part
- [ ] top module
- [ ] AXI modified
  - [x] Decoder address extension
  - [x] 11/21 Arbiter lock extension
  - [x] 11/21 read data channel lock extension
  - [ ] write data channel lock extension
  - [ ] write response channel lock extension
- [x] task finished

#### others

- [x] remove useless comment

### sim

- [ ] prog0
- [ ] prog1
  - [ ] main.c
- [ ] prog2
  - [ ] main.c
- [ ] prog3

## Message boards

11/18 : Add task breakdown items.

## Question unfixed

11/20 : cpu csr stall condition not decided yet,
