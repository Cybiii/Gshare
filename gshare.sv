module top_module(
    input  logic clk,
    input  logic areset,

    input  logic predict_valid,
    input  logic [6:0] predict_pc,
    output logic predict_taken,
    output logic [6:0] predict_history,

    input  logic train_valid,
    input  logic train_taken,
    input  logic train_mispredicted,
    input  logic [6:0] train_history,
    input  logic [6:0] train_pc
);

    logic [1:0] pht [128];
    
    logic [6:0] history;
    
    logic [6:0] predict_index, train_index;
    assign predict_index = predict_pc ^ history;
    assign train_index   = train_pc ^ train_history;
    
    assign predict_taken  = pht[predict_index][1];
    assign predict_history = history;
    
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            for (int i = 0; i < 128; i++)
                pht[i] <= 2'b01;
        end
        else if (train_valid) begin
            if (train_taken) begin
                if (pht[train_index] < 2'b11)
                    pht[train_index] <= pht[train_index] + 1;
            end
            else begin
                if (pht[train_index] > 2'b00)
                    pht[train_index] <= pht[train_index] - 1;
            end
        end
    end
    
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            history <= 7'b0;
        else if (train_valid && train_mispredicted)
            history <= {train_history[5:0], train_taken};
        else if (predict_valid)
            history <= {history[5:0], predict_taken};
    end

endmodule