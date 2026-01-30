# Gshare Branch Predictor

SystemVerilog implementation of the gshare branch predictor. XOR-based indexing to access PHT of 128 2-bit saturating counters. Includes separate prediction and training interfaces to support speculative execution, a gh shift register that tracks recent branch outcomes and corrects itself on mispredictions, and supporting modules including a 2-bit saturating counter FSM.