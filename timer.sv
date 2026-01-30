module top_module(
	input logic clk, 
	input logic load, 
	input logic [9:0] data, 
	output logic tc
);
    logic [9:0] counter;

    always_ff @(posedge clk) begin
        if(load) begin
            counter <= data;
        end
        else if (counter) begin
            counter <= counter - 1;
        end
    end

    always_comb begin
        tc = (!counter);
    end
    
endmodule
