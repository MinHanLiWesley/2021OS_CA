module CPU (clk_i,
            rst_i,
            start_i);
    
    // Ports
    input               clk_i;
    input               rst_i;
    input               start_i;
    
    
    
    
    
    
    
    
    Control Control(
    .Op_i       (Instruction_Memory.instr_o[6:0]),
    .ALUOp_o    (),
    .ALUSrc_o   (),
    .RegWrite_o ()
    );
    
    
    
    Adder Add_PC(
    .data1_in   (PC.pc_o),
    .data2_in   (32'b100),
    .data_o     ()
    );
    
    
    PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (Add_PC.data_o),
    .pc_o       ()
    );
    
    Instruction_Memory Instruction_Memory(
    .addr_i     (PC.pc_o),
    .instr_o    ()
    );
    
    Registers Registers(
    .clk_i      (clk_i),
    .RS1addr_i   (Instruction_Memory.instr_o[19:15]),
    .RS2addr_i   (Instruction_Memory.instr_o[24:20]),
    .RDaddr_i   (Instruction_Memory.instr_o[11:7]),
    .RDdata_i  (ALU.data_o),
    .RegWrite_i (Control.RegWrite_o),
    .RS1data_o   (),
    .RS2data_o   ()
    );
    
    
    MUX32 MUX_ALUSrc(
    .data1_i    (Registers.RS2data_o),
    .data2_i    (Sign_Extend.data_o),
    .select_i   (Control.ALUSrc_o),
    .data_o     ()
    );
    
    
    
    Sign_Extend Sign_Extend(
    .data_i     (Instruction_Memory.instr_o[31:20]),
    .data_o     ()
    );
    
    
    
    ALU ALU(
    .data1_i    (Registers.RS1data_o),
    .data2_i    (MUX_ALUSrc.data_o),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .data_o     (),
    .Zero_o     ()
    );
    
    
    
    ALU_Control ALU_Control(
    .funct_i    ({Instruction_Memory.instr_o[31:25],Instruction_Memory.instr_o[14:12]}),
    .ALUOp_i    (Control.ALUOp_o),
    .ALUCtrl_o  ()
    );
    
    
endmodule
    
