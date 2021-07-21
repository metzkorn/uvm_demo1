class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  function new(string name = "scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  logic [255:0] _mem [logic [31:5]];
  logic [31:0] rdata;
  uvm_analysis_imp #(cache_item, scoreboard) m_analysis_imp;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_analysis_imp = new("m_analysis_imp", this);
    $readmemh("memory.lst", _mem);
  endfunction 
  
  function automatic logic [31:0] read_line(logic [31:0] addr);
    logic [255:0] line;
    logic [31:0] rv;
    line = _mem[addr[31:5]];
    rv = line[8*{addr[4:2], 2'b00} +: 32];
    return rv;
  endfunction : read_line
  
  function automatic void write_line(logic [31:0] addr, logic [31:0] wdata,
                              logic [3:0] mem_byte_enable);
    logic [255:0] line;
    line = _mem[addr[31:5]];
    foreach (mem_byte_enable[i]) begin
        if (mem_byte_enable[i])
            line[8*({addr[4:2], 2'b00} + i) +: 8] = wdata[8*i +: 8];
    end
    _mem[addr[31:5]] = line;
  endfunction : write_line
  
  virtual function write(cache_item m_cache_item);
    logic _read;
    if(m_cache_item.mem_read) begin
      rdata = read_line(m_cache_item.mem_addr);
      _read = 1'b1;
    end 
    else begin 
      write_line(m_cache_item.mem_addr, m_cache_item.mem_wdata, m_cache_item.mem_byte_enable);
      _read = 1'b0; 
    end 
    if (_read) begin
      if (rdata != m_cache_item.mem_rdata) begin
        `uvm_error("SCBD", $sformatf("%0t: ShadowCache Error: Mismatch rdata: Expected %8h, Detected: %8h", $time,
                   rdata, m_cache_item.mem_rdata));
            end
    end
    
  endfunction : write
  
  
  
endclass : scoreboard