module vga_image_display(
    input clk,               // 100 MHz clock from Mimas V2
    input [1:0] filter_sel,  // Filter select: 00 = identity, 01 = invert, 10 = edge
    output hsync,
    output vsync,
    output [3:0] red,
    output [3:0] green,
    output [3:0] blue
);

    // Clock divider
    reg clk25 = 0;
    always @(posedge clk)
        clk25 <= ~clk25;

    // VGA controller
    reg [9:0] h_count = 0;
    reg [9:0] v_count = 0;
    wire [9:0] x = h_count;
    wire [9:0] y = v_count;
    wire video_on = (h_count < 640) && (v_count < 480);

    always @(posedge clk25) begin
        if (h_count == 799) begin
            h_count <= 0;
            if (v_count == 524)
                v_count <= 0;
            else
                v_count <= v_count + 1;
        end else begin
            h_count <= h_count + 1;
        end
    end

    reg hsync_reg, vsync_reg;
    always @(posedge clk25) begin
        hsync_reg <= ~(h_count >= 656 && h_count < 752);
        vsync_reg <= ~(v_count >= 490 && v_count < 492);
    end

    assign hsync = hsync_reg;
    assign vsync = vsync_reg;

    // ROM for 64x64 image
    wire [5:0] img_x = x / 10;
    wire [5:0] img_y = y / 10;
    reg [7:0] image_data;
    reg [7:0] memory [0:4095];
    initial $readmemh("kodim23.hex", memory);
    always @(posedge clk25)
        image_data <= memory[{img_y, img_x}];

    // Filter
    reg [7:0] filtered_pixel;
    always @(*) begin
        case (filter_sel)
            2'b00: filtered_pixel = image_data;         // Identity
            2'b01: filtered_pixel = ~image_data;        // Invert
            2'b10: filtered_pixel = 8'hFF;              // Edge detection placeholder
            default: filtered_pixel = image_data;
        endcase
    end

    assign red   = video_on ? {filtered_pixel[7:5], 1'b0} : 4'b0000;
    assign green = video_on ? {filtered_pixel[4:2], 1'b0} : 4'b0000;
    assign blue  = video_on ? {filtered_pixel[1:0], 2'b00} : 4'b0000;

endmodule
