module top_module (
    input wire clk,  // 50 MHz clock
    output wire hsync,
    output wire vsync,
    output wire [3:0] vga_red,
    output wire [3:0] vga_green,
    output wire [3:0] vga_blue
);
    image_display display (
        .clk(clk),
        .hsync(hsync),
        .vsync(vsync),
        .vga_red(vga_red),
        .vga_green(vga_green),
        .vga_blue(vga_blue)
    );
endmodule
