#Verilog UART Block
This is a verilog block that takes clk, reset, and an UART line as an input,
then outputs a 8-bit bus for the byte, and a 1-bit pulse when there's a valid
byte on that bus

#Signal Overview

1. Signal is high by default
1. The start of every byte there'll be a start bit where it'll be low
1. then 8 bits of data
1. then a stop bit where it'll be high

#Testing
The output is sliced into 4 bits and directed to corresponding LEDs. Using USB
CDC for input data allows user input. An `@` character should have no LED
output, an `E` should result in a `0101` pattern, a `J` should result in a
`1010` pattern, and an `O` should result in all LEDs on.
