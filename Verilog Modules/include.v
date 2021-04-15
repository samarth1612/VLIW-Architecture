// Modules for ADD, FADD, FMUL, LU, MUL
`include "ADD\add_32_rec_dub.v"
`include "FADD\add_32_float.v"
`include "FMUL\mul_32_float.v"
`include "LU\logicUnit.v"
`include "MUL\mul_32_wtm.v"

// Modules required for ADD
`include "ADD\add_32_compute.v"
`include "ADD\add_32_levels.v"

// Modules required for FMUL
`include "FMUL\mul_32_cases.v"
`include "FMUL\mul_32_multiply.v"

// Modules required for MUL
`include "MUL\add_64_levels.v"
`include "MUL\add_64_compute.v"
`include "MUL\add_64_rec_dub.v"

// Resources
`include "RESOURCES\barrel_shifter.v"
`include "RESOURCES\carry.v"
`include "RESOURCES\csa.v"
`include "RESOURCES\dff_n.v"
`include "RESOURCES\kgp.v"
`include "RESOURCES\multiplier.v"
`include "RESOURCES\parallel_prefix.v"
`include "RESOURCES\split.v"
`include "RESOURCES\swap.v"
