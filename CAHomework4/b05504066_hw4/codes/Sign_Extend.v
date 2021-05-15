module Sign_Extend(
    data_i,
    data_o
);
    input   [31:20]     data_i;
    output  [31:0]      data_o;

    //reg
    reg     [31:0]      data_o;      

    always @(*) begin
        if (data_i[31]==1)begin
            data_o = {20'hfffff,data_i};
        end else begin
            data_o = {20'h00000,data_i};
        end
    end
endmodule