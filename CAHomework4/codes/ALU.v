module ALU (data1_i,
            data2_i,
            ALUCtrl_i,
            data_o,
            Zero_o);
    
    //  Ports
    input   [31:0]      data1_i;
    input   [31:0]      data2_i;
    input   [2:0]       ALUCtrl_i;
    output  [31:0]      data_o;
    output              Zero_o;
    // Wires & Registers
    reg [31:0]      i;
    reg [31:0]          data_o;
    reg [31:0]          tmp;
    
    
    
    always @(*) begin
        case(ALUCtrl_i)
            // and
            1 :
            begin
                data_o = data1_i & data2_i;
            end
            // xor
            2 :
            begin
                data_o = data1_i ^ data2_i;
            end
            // sll
            3 :
            begin
                data_o = data1_i << data2_i;
            end
            // add
            4 :
            begin
                data_o = data1_i + data2_i;
            end
            // sub
            5 :
            begin
                data_o = data1_i - data2_i;
            end
            // mul
            6 :
            begin
                data_o = data1_i * data2_i;
            end
            // sra
            7 :
            begin
                data_o = $signed(data1_i) >>> $signed(data2_i[4:0]);
            end
        endcase
        
    end
    assign Zero_o = 0;
    
endmodule
