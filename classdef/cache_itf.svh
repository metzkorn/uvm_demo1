interface cache_itf
#(
    parameter int BURST_LEN = 64,
	 parameter int CACHELINE_LEN = 256
)
(
	input bit clk
);
	

	logic rst;
	logic pm_error;
	logic resp_i, resp_o;
	logic write_i, write_o;
	logic read_i, read_o; 
	logic [31:0] mem_rdata, mem_wdata, address_i, address_o;
	logic [CACHELINE_LEN - 1:0] pmem_rdata, pmem_wdata;
	logic [3:0] mem_byte_enable;
	mailbox #(string) path_mb; 
	initial path_mb = new(); 
	
	clocking mcb @(posedge clk);
		input rst = rst, addr = address_o, write = write_o, read = read_o, wdata = pmem_wdata ;
		output resp = resp_i, error = pm_error, rdata = pmem_rdata;
	endclocking
	
	clocking tb @(posedge clk);
		input mem_rdata, mem_resp = resp_o, pmem_read = read_o, pmem_write = write_o, 
				pmem_address = address_o, pmem_rdata, pmem_wdata, pmem_resp = resp_i;
		output mem_read = read_i, mem_write = write_i, mem_address = address_i, mem_byte_enable,
				 mem_wdata;
	endclocking
	
	
	modport mem (clocking mcb, ref path_mb); 

endinterface : cache_itf