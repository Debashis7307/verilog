module fsm (
    output reg Dout,
    input wire clk, reset, in
);

    parameter Start = 2'b00, Midway = 2'b01, Done = 2'b10;

    reg [1:0] current_state, next_state;

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
            Start: Dout = 1'b0;
            Midway: Dout = 1'b0;
            Done: begin 
                if (in) 
                    Dout = 1'b1;
                else 
                    Dout = 1'b0;
            end
            default: Dout = 1'b0;
        endcase
    end

endmodule


module tb_fsm;

    reg clk;
    reg reset;
    reg in;
    wire Dout;

    fsm uut (
        .clk(clk),
        .reset(reset),
        .in(in),
        .Dout(Dout)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin

        $monitor("Time: %0d, Clock: %b, reset: %b, in: %b,  state: %b, Dout: %b", $time,clk, reset, in, uut.current_state, Dout);

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