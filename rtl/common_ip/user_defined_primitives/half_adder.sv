module half_adder (
                   input logic a,
                   input logic b,
                   output logic sum,
                   output logic carry
                   );
`ifdef USER_DEFINED_PRIMITIVES
  table
    //a b sum carry
      0 0 :0  :0
      0 1 :1  :0
      1 0 :1  :0
      1 1 :0  :1
  endtable
`elsif PRIMITIVES
  xor (sum, a, b);
  and (carry, a, b);
`else
  assign sum = a ^ b;
  assign carry = a && b;
`endif
endmodule
