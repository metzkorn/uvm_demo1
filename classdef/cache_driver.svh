class cache_driver extends uvm_driver #(cache_item);
  `uvm_component_utils(cache_driver)
  function new(string name = "cache_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction 
  virtual cache_itf vif; 
  
  virtual function void build_phase(uvm_phase phase); 
    super.build_phase(phase); 
    if(!uvm_config_db#(virtual cache_itf)::get(this, "", "cache_itf", vif)) 	begin
      `uvm_fatal("DRV", "Could not get if")
    end 
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      cache_item cache_item_inst;
      `uvm_info("DRV", $sformatf("Wait for item from sequencer"), UVM_HIGH)
      seq_item_port.get_next_item(cache_item_inst);
      drive_item(cache_item_inst);
      seq_item_port.item_done();
    end 
  endtask  
  virtual task drive_item(cache_item cache_item_inst);
    @(vif.tb);
    vif.tb.mem_read        <= cache_item_inst.mem_read;
    vif.tb.mem_write       <= cache_item_inst.mem_write;
    vif.tb.mem_address     <= cache_item_inst.mem_addr;
    vif.tb.mem_byte_enable <= cache_item_inst.mem_byte_enable;
    vif.tb.mem_wdata       <= cache_item_inst.mem_wdata; 
    wait(vif.tb.mem_resp);
  endtask 
      
endclass : cache_driver