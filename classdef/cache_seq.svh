class cache_sequence extends uvm_sequence;
  `uvm_object_utils(cache_sequence)
  
  function new(string name = "cache_sequence");
    super.new(name);
  endfunction 
  
  rand int num;
  constraint c1 {soft num inside{[10:50]};}
  
  virtual task body();
    for(int i = 0; i < num; i++) begin
      cache_item cache_item_inst = cache_item::type_id::create("cache_item_inst");
      start_item(cache_item_inst);
      if(!cache_item_inst.randomize())
        `uvm_error("run_phase", "seq randomization failure");
      `uvm_info("SEQ", $sformatf("Generate new item: %s", cache_item_inst.convert2string()), UVM_HIGH)
      finish_item(cache_item_inst);
    end 
    
  endtask
endclass : cache_sequence