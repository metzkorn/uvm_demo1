class cache_env extends uvm_env; 
  `uvm_component_utils(cache_env)
  
  function new (string name = "env", uvm_component parent); 
    super.new(name, parent);
  endfunction
  agent a0; 
  scoreboard sb0;
  

  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    a0 = agent::type_id::create("a0", this);
    sb0 = scoreboard::type_id::create("sb0", this);
  endfunction: build_phase
  
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    a0.m0.mon_analysis_port.connect(sb0.m_analysis_imp);
  endfunction : connect_phase
  
  task run_phase(uvm_phase phase); 
    //set_report_verbosity_level(UVM_MEDIUM);
    //uvm_report_info (get_name(), $sformatf(UVM Simulation started.), UVM_MEDIUM, `__FILE__, `__LINE__);
    //`uvm_info (get_name(), $sformatf("Finishing up with run phase..."), UVM_LOW)
  endtask : run_phase
endclass : cache_env