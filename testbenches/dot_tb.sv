`timescale 1ps/1ps

module dot_tb();

  // Clock and reset
  reg clk;
  reg rst_n;

  // Slave interface signals
  wire slave_waitrequest;
  reg [3:0] slave_address;
  reg slave_read;
  wire [31:0] slave_readdata;
  reg slave_write;
  reg [31:0] slave_writedata;

  // Master interface signals
  reg master_waitrequest;
  wire [31:0] master_address;
  wire master_read;
  reg [31:0] master_readdata;
  reg master_readdatavalid;
  wire master_write;
  wire [31:0] master_writedata;

  // Instantiate the DUT
  dot dut (
    .clk(clk),
    .rst_n(rst_n),
    .slave_waitrequest(slave_waitrequest),
    .slave_address(slave_address),
    .slave_read(slave_read),
    .slave_readdata(slave_readdata),
    .slave_write(slave_write),
    .slave_writedata(slave_writedata),
    .master_waitrequest(master_waitrequest),
    .master_address(master_address),
    .master_read(master_read),
    .master_readdata(master_readdata),
    .master_readdatavalid(master_readdatavalid),
    .master_write(master_write),
    .master_writedata(master_writedata)
  );

  // Clock generation
  always #5 clk = ~clk;

  // Test vectors
  logic [31:0] w_addr = 32'h1000;
  logic [31:0] if_addr = 32'h2000;
  logic [31:0] n_words = 4;
  logic [31:0] expected_result = 32'd2340; // Pre-calculated expected result

  // Test procedure
  initial begin
    // Initialize signals
    clk = 0;
    rst_n = 1;
    slave_address = 0;
    slave_read = 0;
    slave_write = 0;
    slave_writedata = 0;
    master_waitrequest = 0;
    master_readdata = 0;
    master_readdatavalid = 0;

    // Reset the DUT
    #10 rst_n = 0;

    // Write w_addr
    @(posedge clk);
    slave_address = 4'd2;
    slave_write = 1;
    slave_writedata = w_addr;
    @(posedge clk);
    while (slave_waitrequest) @(posedge clk);
    slave_write = 0;

    // Write if_addr
    @(posedge clk);
    slave_address = 4'd3;
    slave_write = 1;
    slave_writedata = if_addr;
    @(posedge clk);
    while (slave_waitrequest) @(posedge clk);
    slave_write = 0;

    // Write n_words
    @(posedge clk);
    slave_address = 4'd5;
    slave_write = 1;
    slave_writedata = n_words;
    @(posedge clk);
    while (slave_waitrequest) @(posedge clk);
    slave_write = 0;

    // Start computation
    @(posedge clk);
    slave_address = 4'd0;
    slave_write = 1;
    slave_writedata = 1; // Any non-zero value to start
    @(posedge clk);
    while (slave_waitrequest) @(posedge clk);
    slave_write = 0;

    // Simulate SDRAM responses
    fork
      begin
        repeat (n_words) begin
          @(posedge clk iff master_read);
          #2 master_readdata = $urandom_range(65536, 655360);
          master_readdatavalid = 1;
          @(posedge clk);
          master_readdatavalid = 0;
        end
      end
    join_none

    // Wait for computation to complete and read result
    @(posedge clk);
    slave_address = 4'd1; // Assume address 1 is for reading result
    slave_read = 1;
    @(posedge clk);
    while (slave_waitrequest) @(posedge clk);
    
    // Check result
    if (slave_readdata == expected_result)
      $display("Test passed: Expected %0d, Got %0d", expected_result, slave_readdata);
    else
      $display("Test failed: Expected %0d, Got %0d", expected_result, slave_readdata);

    slave_read = 0;

    // End simulation
  end

  // Optional: Dump waveforms
  initial begin
    $dumpfile("dot_tb.vcd");
    $dumpvars(0, dot_tb);
  end

endmodule