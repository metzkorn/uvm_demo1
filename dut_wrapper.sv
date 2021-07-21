module dut_wrapper(cache_itf itf);

  cache dut ( .clk(itf.clk),
             .rst(itf.rst),
             .mem_read(itf.read_i),
             .mem_write(itf.write_i),
             .mem_address(itf.address_i),
             .mem_rdata(itf.mem_rdata),
             .mem_wdata(itf.mem_wdata),
             .mem_resp(itf.resp_o),
             .mem_byte_enable(itf.mem_byte_enable),
             .pmem_rdata(itf.pmem_rdata),
             .pmem_wdata(itf.pmem_wdata),
             .pmem_resp(itf.resp_i),
             .pmem_read(itf.read_o),
             .pmem_write(itf.write_o),
             .pmem_address(itf.address_o)
             );
  
endmodule : dut_wrapper

