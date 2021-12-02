# pipelined_cpu
A piplelined MIPS cpu with included support for hazard detection and avoidance

This cpu has a five stage pipelined, with hazard detection as well as a forwarding unit to detect and prevent data dependencies in code.
The test bench for these files include code cases that have data dependencies and the comments indicate what the correct output should be with correct forwarding. 
