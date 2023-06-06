onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib mult_64_opt

do {wave.do}

view wave
view structure
view signals

do {mult_64.udo}

run -all

quit -force
