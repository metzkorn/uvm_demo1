`include "cache_itf.sv"
`include "cache_pkg.sv"
`include "dut_wrapper.sv"
`include "param_memory.sv"
module testbench;
  import cache_pkg::*; 
  import uvm_pkg::*;
  bit clk;
  always #5 clk = clk === 1'b0; 
  cache_itf itf(clk); 

  
  initial begin
    $dumpfile("results.vcd");
    $dumpvars;
    itf.path_mb.put("memory.lst");
    clk <= 0; 
    uvm_config_db#(virtual cache_itf)::set(null, "uvm_test_top", "cache_itf", itf);
    run_test("base_test"); 
    
  end
   dut_wrapper dut_wr0(itf);
  ParamMemory #(25, 13, 1, 256, 512) memory(itf);


  
  
  
endmodule : testbench