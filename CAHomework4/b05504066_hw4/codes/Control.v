module Control (Op_i,
                ALUOp_o,
                ALUSrc_o,
                RegWrite_o);
    
    //ports
    input     [6:0]      Op_i;
    output reg  [1:0]       ALUOp_o;
    output reg       ALUSrc_o;
    output reg       RegWrite_o;
    
    always @(*) begin
        if (Op_i == 51) begin
            ALUOp_o    <= 2'b10;
            ALUSrc_o   <= 0;
            RegWrite_o <= 1;
            end else if (Op_i == 19) begin
            ALUOp_o    <= 2'b00;
            ALUSrc_o   <= 1;
            RegWrite_o <= 1;
            
        end
    end
endmodule
    //Wires & Registers
