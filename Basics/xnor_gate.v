module xnor_gate(
  input a,b,
  output out
);

assign out = ~(a^b);

endmodule