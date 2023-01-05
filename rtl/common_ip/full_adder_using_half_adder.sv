module full_adder_using_half_adder(
                                   input logic a,
                                   input logic b,
                                   input logic c,
                                   output logic sum,
                                   output logic carry
                                   );
logic ha1_sum;
logic ha1_carry;
logic ha2_carry;
half_adder ha1(.a(a),.b(b),.sum(ha1_sum),.carry(ha1_carry));
half_adder ha2(.a(c),.b(ha1_sum),.sum(sum),.carry(ha2_carry));
assign carry = ha1_carry || ha2_carry;

endmodule
