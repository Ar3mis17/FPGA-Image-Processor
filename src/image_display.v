module image_display (
    input wire clk,
    output wire hsync,
    output wire vsync,
    output wire [3:0] vga_red,
    output wire [3:0] vga_green,
    output wire [3:0] vga_blue
);
    wire [9:0] x, y;
    wire display_area;
    wire [23:0] pixel;

    reg [16:0] addr;

    vga_sync sync_inst (
        .clk(clk),
        .hsync(hsync),
        .vsync(vsync),
        .x(x),
        .y(y),
        .display_area(display_area)
    );

    rom_image rom (
        .clk(clk),
        .addr(addr),
        .data(pixel)
    );

    always @(*) begin
        addr = y * 512 + x;  // For 512x512 images
    end

    assign vga_red   = display_area ? pixel[23:20] : 0;
    assign vga_green = display_area ? pixel[15:12] : 0;
    assign vga_blue  = display_area ? pixel[7:4]   : 0;
endmodule
