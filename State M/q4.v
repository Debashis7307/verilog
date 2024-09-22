module fsm_binary (
    input wire clk, reset, in,
    output reg out
);

    parameter S0 = 4'b0001, S1 = 4'b0010, S2 = 4'b0100, S3 = 40'b1000;
    reg [3:0] current_state, next_state;
    always @(*) begin
        case (current_state)
            S0: begin
                if (in)
                    next_state = S1;
                else
                    next_state = S0;
            end

            S1: begin
                if (in)
                    next_state = S3;
                else
                    next_state = S2;
            end

            S2: begin
                if (in)
                    next_state = S3;
                else
                    next_state = S0;
            end

            S3: begin
                if (in)
                    next_state = S0;
                else
                    next_state = S3;
            end

            default: next_state = S0;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            S0: begin 
                if (in) 
                    out = 1'b1;
                else 
                    out = 1'b0;
                end
            S1:  begin 
                if (in) 
                    out = 1'b0;
                else 
                    out = 1'b1;
                end
            S2: begin 
                if (in) 
                    out = 1'b1;
                else 
                    out = 1'b0;
                end
            S3: begin 
                if (in) 
                    out = 1'b1;
                else 
                    out = 1'b0;
                end
            default: out = 1'b0;
        endcase
    end

endmodule


module tb_fsm_binary;

    reg clk;
    reg reset;
    reg in;
    wire out;


    fsm_binary uut (
        .clk(clk),
        .reset(reset),
        .in(in),
        .out(out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin

        $monitor("Time: %0d,clock:%b reset: %b, in: %b, state: %b, out: %b", $time,clk, reset, in, uut.current_state , out);

        reset = 1;
        in = 0;
        #10;

        reset = 0;
        #10;

        in = 1; #10;
        in = 1; #10;
        in = 1; #10;
        in = 1; #10;
        in = 0; #10;
        in = 1; #10;
        in = 0; #10;
        in = 1; #10;
        in = 0; #10;
        in = 1; #10;
        in = 0; #10;
        in = 0; #10;

        $finish;
    end
endmodule
