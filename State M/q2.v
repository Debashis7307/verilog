module fsm_one_hot (
    output reg out,
    input wire clk, reset, in
);

    parameter Start = 3'b001, Midway = 3'b010, Done = 3'b100;

    reg [2:0] current_state, next_state;

    always @(*) begin
        case (current_state)
            Start: begin
                if (in)
                    next_state = Midway;
                else
                    next_state = Start;
            end

            Midway: begin
                    next_state = Done;
            end

            Done: begin
                    next_state = Start;
            end

            default: next_state = Start;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= Start;
        else
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            Start: out = 1'b0;
            Midway: out = 1'b0;
            Done: out = 1'b1;
            default: out = 1'b0;
        endcase
    end

endmodule


module tb_fsm_one_hot;
    reg clk;
    reg reset;
    reg in;
    wire out;

    fsm_one_hot uut (
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

        $monitor("Time: %0d,clock: %b, reset: %b, in: %b, out: %b, state: %b", $time,clk, reset, in, out, uut.current_state);

        reset = 1;
        in = 0;
        #10;

        reset = 0;
        #10;

        in = 1; #10;
        in = 1; #10;
        in = 1; #10;
        in = 0; #10;
        in = 1; #10;
        in = 0; #10;
        in = 1; #10;
        in = 0; #10;
        in = 1; #10;

        $finish;
    end
endmodule
