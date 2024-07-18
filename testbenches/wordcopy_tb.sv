 module wordcopy_tb();

  // Clock and reset
  logic clk;
  logic rst_n;

  // Slave interface signals
  logic slave_waitrequest;
  logic [3:0] slave_address;
  logic slave_read;
  logic [31:0] slave_readdata;
  logic slave_write;
  logic [31:0] slave_writedata;

  // Master interface signals
  logic master_waitrequest;
  logic [31:0] master_address;
  logic master_read;
  logic [31:0] master_readdata;
  logic master_readdatavalid;
  logic master_write;
  logic [31:0] master_writedata;

  // Instantiate the DUT
  wordcopy dut (
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

  // Test stimulus
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

    // Apply reset
    #10 rst_n = 1;
    #10 rst_n = 0;

    // Test case: Write destination address, source address, and word count
    #10 slave_write = 1;
    slave_address = 4'd1;
    slave_writedata = 32'h1000_0000; // Destination address
    #10 slave_write = 0;

    #10 slave_write = 1;
    slave_address = 4'd2;
    slave_writedata = 32'h2000_0000; // Source address
    #10 slave_write = 0;

    #10 slave_write = 1;
    slave_address = 4'd3;
    slave_writedata = 32'd4; // Number of words to copy
    #10 slave_write = 0;

    // Start the copy operation
    #10 slave_write = 1;
    slave_address = 4'd0;
    slave_writedata = 32'd1; // Any value to start
    #10 slave_write = 0;

    // Simulate SDRAM read and write operations
    repeat(4) begin
      #10 master_waitrequest = 1;
      #20 master_waitrequest = 0;
      #10 master_readdatavalid = 1;
      master_readdata = $random; // Generate random data to copy
      #10 master_readdatavalid = 0;
      #10 master_waitrequest = 1;
      #20 master_waitrequest = 0;
    end

    // End simulation
    
  end

  // Monitor
  always @(posedge clk) begin
    if (master_read)
      $display("Time %0t: Master Read  - Address: %h", $time, master_address);
    if (master_write)
      $display("Time %0t: Master Write - Address: %h, Data: %h", $time, master_address, master_writedata);
  end

endmodule