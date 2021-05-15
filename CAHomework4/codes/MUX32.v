module MUX32(data1_i,
             data2_i,
             select_i,
             data_o);
    input [31:0]    data1_i;
    input [31:0]    data2_i;
    input select_i;
    output  reg [31:0] data_o;
    always @(*) begin
        if (select_i == 0) begin
            data_o <= data1_i;
        end
        else begin
            data_o <= data2_i;
        end
        
    end
endmodule
