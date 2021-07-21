class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  function new(string name = "monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction 
  
  uvm_analysis_port #(cache_item) mon_analysis_port;
  virtual cache_itf vif;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual cache_itf)::get(this, "", "cache_itf", vif)) begin
      `uvm_fatal("MON", "Could not get vif")
    end
    mon_analysis_port = new("mon_analysis_port", this); 
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      @(vif.tb);
      if(!vif.rst) begin
        cache_item cache_item_inst = cache_item::type_id::create("cache_item_inst");
        cache_item_inst.mem_addr        = vif.address_i;
        cache_item_inst.mem_read        = vif.read_i;
        cache_item_inst.mem_write       = vif.write_i;
        cache_item_inst.mem_wdata       = vif.mem_wdata;
        cache_item_inst.mem_byte_enable = vif.mem_byte_enable;
        cache_item_inst.mem_rdata       = vif.tb.mem_rdata;
        cache_item_inst.mem_resp        = vif.tb.mem_resp; 
        `uvm_info("MON", "Saw item, not yet written", UVM_HIGH)
        if(vif.tb.mem_resp == 1'b1)
          mon_analysis_port.write(cache_item_inst);
         `uvm_info("MON", $sformatf("Saw item %s", cache_item_inst.convert2string()), UVM_HIGH)
      end 
     
                
    end
  endtask
endclass : monitor