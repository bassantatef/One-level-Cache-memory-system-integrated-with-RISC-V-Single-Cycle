module controller(
    input   wire mem_read,mem_write,ready,clk,reset,hit,
    output  reg  stall,main_read,main_write,refill,update
);

localparam  [1:0]   idle            = 2'b00 ,
                    reading         = 2'b01 ,
                    writing         = 2'b11 ;

reg         [1:0]  current_state , next_state ;

always @(negedge clk or negedge reset)         
begin
    if(!reset) begin
        current_state <= idle;
    end  
    else begin
        current_state <= next_state;
    end
end
always @(*)
begin
    case(current_state)
        idle            :   begin
                                if(mem_read && !mem_write)
                                    next_state = reading ;
                                else if (!mem_read && mem_write)
                                    next_state = writing ;
                                else
                                    next_state = idle ;
                            end
          
        reading         :   begin
                                if(mem_read && !mem_write)
                                    next_state = reading ;
                                else if (!mem_read && mem_write)
                                    next_state = writing ;
                                else if(hit == 1'b1)
                                    next_state = idle ;
                                else
                                    next_state = reading ;
                            end   
    
        writing         :   begin
                                if (ready == 1'b1)
                                next_state = idle;
                                else 
                                next_state = writing;
                            end

        default         :   begin
                                next_state = idle;
                            end            
    endcase
end
   
always@(*)
begin
    
                                    stall       = 1'b0 ;
                                    main_read   = 1'b0 ;
                                    main_write  = 1'b0 ;
                                    refill      = 1'b0 ;
                                    update      = 1'b0 ;

    case(current_state)
            idle            :   begin
                                    stall       = 1'b0 ;
                                    main_read   = 1'b0 ;
                                    main_write  = 1'b0 ;
                                    refill      = 1'b0 ;
                                    update      = 1'b0 ;
                                end
          
            reading         :   begin
                                    if (hit) begin
                                        stall       = 1'b0 ;
                                        main_read   = 1'b0 ;
                                        main_write  = 1'b0 ;
                                        refill      = 1'b1 ;
                                        update      = 1'b1 ;    
                                    end 
                                    else if (ready)
                                    begin
                                        stall       = 1'b0 ;
                                        main_read   = 1'b0 ;
                                        main_write  = 1'b0 ;
                                        refill      = 1'b0 ;
                                        update      = 1'b1 ;
                                    end
                                    else
                                    begin
                                        stall       = 1'b1 ;
                                        main_read   = 1'b1 ;
                                        main_write  = 1'b0 ;
                                        refill      = 1'b0 ;
                                        update      = 1'b0 ;
                                    end
                                end
         
            writing         :   begin
                                    stall       = 1'b1 ;
                                    main_read   = 1'b0 ;
                                    update      = 1'b0 ;

                                    if (ready == 1'b1) begin
                                        main_write  = 1'b0 ;
                                    end 
                                    else begin
                                        main_write  = 1'b1 ;
                                    end

                                    if (hit == 1'b1) begin
                                        refill      = 1'b1 ;
                                    end 
                                    else begin
                                        refill      = 1'b0 ;
                                    end
                                end

            default         :   begin
                                    stall       = 1'b0 ;
                                    main_read   = 1'b0 ;
                                    main_write  = 1'b0 ;
                                    refill      = 1'b0 ;
                                    update      = 1'b0 ;
                                end

        endcase
end

endmodule
