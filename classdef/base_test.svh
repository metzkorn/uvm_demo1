class base_test extends uvm_test; 
  `uvm_component_utils(base_test)
  cache_env m_top_env;
  cache_sequence seq;
  virtual cache_itf vif;
  
  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase); 
    m_top_env = cache_env::type_id::create("m_top_env", this); 
    if(! uvm_config_db #(virtual cache_itf) :: get(this, "", "cache_itf", vif)) begin
      `uvm_error("TEST", "Did not get vif")
    end 
    uvm_config_db#(virtual cache_itf)::set(this, "m_top_env.a0.*", "cache_itf", vif);
    
    seq = cache_sequence::type_id::create("seq");
    if(!seq.randomize()) begin
      `uvm_fatal("TEST", "sequence not randomized")
    end 
  endfunction : build_phase
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    apply_reset();
    seq.start(m_top_env.a0.s0);
    #200;
    phase.drop_objection(this);
  endtask : run_phase
  
  virtual task apply_reset();
    vif.rst <= 1'b1;
    vif.write_i <= 1'b0;
    vif.read_i <= 1'b0;
    vif.mem_rdata <= 32'b0;
    vif.mem_wdata <= 32'b0;
    vif.resp_i <= 1'b0; 
    vif.mem_byte_enable <= 4'b0; 
    repeat(5) @ (posedge vif.clk);
    vif.rst <= 1'b0;
    repeat(10) @ (posedge vif.clk);
  endtask
  
  virtual function void end_of_elaboration_phase (uvm_phase phase); 
    uvm_top.print_topology(); 
  endfunction 
  
  
endclass : base_test