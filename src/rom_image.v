module rom_image (
    input wire clk,
    input wire [16:0] addr,    // Up to 512*512 = 262144 = 18-bit
    output reg [23:0] data     // 8 bits each for R, G, B
);
    reg [23:0] memory [0:262143]; // Adjust size if smaller resolution

    initial begin
        $readmemh("hex_image.hex", memory);
    end

    always @(posedge clk)
        data <= memory[addr];
endmodule
