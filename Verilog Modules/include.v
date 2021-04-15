// Modules for ADD, FADD, FMUL, LU, MUL
`include "ADD\add_32_rec_dub.v"
`include "FADD\add_32_float.v"
`include "FMUL\mul_32_float.v"
`include "LU\logicUnit.v"
`include "MUL\mul_32_wtm.v"

// Dependencies for ADD module
`include "ADD\add_32_compute.v"
`include "ADD\add_32_levels.v"

// Dependencies for FMUL module
`include "FMUL\mul_32_cases.v"
`include "FMUL\mul_32_multiply.v"

// Dependencies for MUL module
`include "MUL\add_64_levels.v"
`include "MUL\add_64_compute.v"
`include "MUL\add_64_rec_dub.v"

// Resources for the verilog modules
`include "RESOURCES\barrel_shifter.v"
`include "RESOURCES\carry.v"
`include "RESOURCES\csa.v"
`include "RESOURCES\dff_n.v"
`include "RESOURCES\kgp.v"
`include "RESOURCES\multiplier.v"
`include "RESOURCES\parallel_prefix.v"
`include "RESOURCES\split.v"
`include "RESOURCES\swap.v"

// Register file
`include "REG FILE\RegisterFile.v"
