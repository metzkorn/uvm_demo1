`ifndef CACHE_ITEM
`define CACHE_ITEM


class cache_item extends uvm_sequence_item;
    rand bit [31:0] mem_addr;
    rand bit mem_read;
    rand bit mem_write;
    rand bit [31:0] mem_wdata;
    rand bit [3:0] mem_byte_enable; 
    bit [31:0] mem_rdata; 
    bit mem_resp; 
  constraint wr_rd_c {mem_read != mem_write;}

    `uvm_object_utils_begin(cache_item)
        `uvm_field_int(mem_addr, UVM_DEFAULT)
        `uvm_field_int(mem_read, UVM_DEFAULT)
        `uvm_field_int(mem_write, UVM_DEFAULT)
        `uvm_field_int(mem_wdata, UVM_DEFAULT)
        `uvm_field_int(mem_rdata, UVM_DEFAULT)
	    `uvm_field_int(mem_byte_enable, UVM_DEFAULT)
        `uvm_field_int(mem_resp, UVM_DEFAULT)
    `uvm_object_utils_end
	
 	virtual function string convert2string(); 
      return $sformatf("addr:\t%0h\n mem_read:\t%b\n mem_write:\t%b\n mem_wdata:\t%0h\n mem_rdata:\t%0h\n mem_resp:\t%b\n mbe:\t%h\n", mem_addr, mem_read, mem_write, mem_wdata, mem_rdata, mem_resp, mem_byte_enable);
    endfunction : convert2string

    function new(string name = "cache_item");
        super.new(name);
    endfunction 
  
endclass : cache_item

`endif 