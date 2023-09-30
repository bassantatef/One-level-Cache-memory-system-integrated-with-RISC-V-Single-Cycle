module RISCV_tb ();

reg                 clk_tb    ;
reg                 rst_tb    ;       


initial begin
    clk_tb = 1'b0 ;
    rst_tb = 1'b1 ;
    #5
    rst_tb = 1'b0 ;
    #5
    rst_tb = 1'b1 ;
  
end


// GENERATE CLOCK
always #5 clk_tb = ~clk_tb ;

// DUT instantiation

RISCV_top DUT (
    .clk  (clk_tb) ,
    .rst  (rst_tb) 
);

endmodule