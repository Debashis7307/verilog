module d_flip_flop (
    input wire clk, reset,d,
    output reg q
);

    // State declaration
    reg [1:0] state, next_state;

    // State definitions
    localparam[1:0] S0 = 2'b00, S1 = 2'b01;

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    always @(state, d) begin
        case (state)
            S0: begin
                q <= 1'b0;
                if (d) next_state = S1;
                else next_state = S0;
            end
            S1: begin
                q <= 1'b1;
                if (!d) next_state = S0;
                else next_state = S1;
            end
        endcase
    end

endmodule

module tb_d_flip_flop(
    output reg clk,
    output reg reset,
    output reg d,
    input wire q
);

    initial begin
        clk = 1'b0;
        reset = 1'b1;
        $monitor("At time %t, when clk=%b, reset=%b, d=%b, then q=%b",$time,clk,reset,d,q);
        d=1'b0;
        #10 d=1'b1;
        #10 d=1'b0;
        #10 d=1'b1;
        #10 $finish;
    end

    always #5 clk = ~clk ;

endmodule

module wb;
    wire clk,reset,d,q;
    initial begin
        $dumpfile("dff.vcd");
        $dumpvars(0,wb);
    end
    d_flip_flop dut (clk,reset,d,q);
    tb_d_flip_flop tb (clk,reset,d,q);
endmodule
