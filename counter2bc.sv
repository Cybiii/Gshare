    module top_module(
        input logic clk,
        input logic areset,
        input logic train_valid,
        input logic train_taken,
        output logic [1:0] state
    );
        logic taken, not_taken;
        assign taken = train_valid && train_taken;
        assign not_taken = train_valid && ~train_taken;

        typedef enum logic [1:0] {
            SNT,
            WNT,
            WT,
            ST
        } state_t;

        state_t curr, next_state;

        // fsm comb logic
        always_comb begin
            case (curr)
                SNT: next_state = (taken) ? WNT : (not_taken ? SNT : SNT);
                WNT: next_state = (taken) ? WT : (not_taken ? SNT : WNT);
                WT: next_state = (taken) ? ST : (not_taken ? WNT : WT);
                ST: next_state = (taken) ? ST : (not_taken ?  WT : ST);
                default: next_state = WNT;
            endcase
        end

        always_ff@(posedge clk or posedge areset) begin
            if(areset) begin
                curr <= WNT;
            end
            else begin
                curr <= next_state;
            end
        end

        assign state = curr;

    endmodule
