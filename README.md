# FPGA-Based Real-Time Image Processor with Multiple Effects

This project is a real-time image processing system implemented on a Xilinx Spartan-6 FPGA using Verilog. The system reads an image from memory and displays it on a VGA monitor with one of three user-selectable effects: **Original**, **Inverse**, or **Border**.

![RTL Schematic](images/rtl_schematic.png)

---

## Key Features

- **Real-Time Video Processing**: Applies effects to the image with minimal latency, running directly on the hardware.
- **Three Selectable Output Modes**:
    - **Original**: Displays the image without modification.
    - **Inverse**: Displays a "negative" of the image by inverting pixel color values.
    - **Border**: Draws a static border around the original image.
- **VGA Display Controller**: Generates standard 640x480 VGA signals to display the output on any compatible monitor.
- **Python Script for Image Conversion**: Includes a helper script to convert standard image files into the HEX format required for the FPGA's memory.
- **Modular Verilog Design**: Built with a clean architecture that separates the VGA controller, memory, and effects logic for easy modification.
- **Platform**: Targeted for the Xilinx Spartan-6 XC6SLX9 FPGA and developed using Xilinx ISE 14.7.

---

## The Effects

The system can apply one of three effects, selected by the user via switches on the FPGA board:

1.  **Original**: The image stored in the internal ROM is passed through to the display without any changes.
2.  **Inverse**: The color value of each pixel is inverted, creating a negative image. For an 8-bit color channel, the new value is calculated as `255 - original_value`.
3.  **Border**: The logic checks the current pixel coordinates. If the coordinates are within a defined edge area of the screen, a fixed border color is displayed; otherwise, the original pixel from the image is shown.

---

## HEX File Generation

The `kodim23.hex` file, which contains the image data for the FPGA's ROM, was generated from a source image using a Python script.

To regenerate this file, navigate to the `scripts` folder and run the Python script. You may need to install the Pillow library first.

```sh
# Install required library
pip install Pillow

# Run the script to generate the .hex file
python your_script_name.py
```

---

## How to Use

1.  **Clone the repository.**
2.  **(Optional)** Run the Python script in the `scripts` folder to generate a new `.hex` file from your own image.
3.  **Open the Project**: Launch Xilinx ISE 14.7 and open the `vgaprocess.xise` project file.
4.  **Generate Programming File**: Run the "Implement Design" process to synthesize, place & route, and generate the bitstream file (`.bit`).
5.  **Program the FPGA**: Use the Xilinx iMPACT tool to load the generated `.bit` file onto the Spartan-6 FPGA.
6.  [cite_start]**Select an Effect**: Use the two filter selection switches on the FPGA board (mapped to `SW0` and `SW1` in the design) to choose the output:
    - **Original Image**: Both switches OFF (`00`)
    - **Inverse Image**: `SW0` ON, `SW1` OFF (`01`)
    - **Border Image**: `SW1` ON, `SW0` OFF (`10`)

---

## Hardware and Software Requirements

- **FPGA Board**: A Xilinx Spartan-6 based board (e.g., Mimas V2).
- **Software**: Xilinx ISE Project Navigator 14.7.
- **Display**: A standard VGA monitor.
- **Python**: Python 3.x to run the helper script.

---

## Resource Utilization

The design is highly efficient, using a very small fraction of the FPGA's available resources on the **Xilinx Spartan-6 XC6SLX9**.

- **Slice LUTs**: 52 out of 5,720 (1%)
- **Slice Registers**: 27 out of 11,440 (1%)
- **Bonded IOBs**: 18 out of 200 (9%)
- **RAMB16BWERs**: 2 out of 32 (6%)