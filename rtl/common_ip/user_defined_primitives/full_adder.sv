module full_adder_using_basic_gates(
                                   input logic a,
                                   input logic b,
                                   input logic c,
                                   output logic sum,
                                   output logic carry
                                   );
`ifdef PRIMITIVES
logic xor_ab;
logic and_ab;
logic and_bc;
logic and_ca;
`endif

`ifdef USER_DEFINED_PRIMITIVES
  table
    //a b c sum carry
      0 0 0 :0  :0;
      0 0 1 :1  :0;
      0 1 0 :1  :0;
      0 1 1 :0  :1;
      1 0 0 :1  :0;
      1 0 1 :0  :1;
      1 1 0 :0  :1;
      1 1 1 :1  :1;
  endtable
`elsif PRIMITIVES
  xor (xor_ab,a,b);
  xor (sum,xor_ab,c);
  and (and_ab,a,b);
  and (and_bc,b,c);
  and (and_ca,c,a);
  or (carry,and_ab,and_bc,and_ca);
`else
  assign sum = a ^ b ^ c;
  assign carry = (a && b) || (b && c) || (c && a);
`endif

endmodule
