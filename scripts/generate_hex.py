from PIL import Image

def bmp_to_hex(image_path, output_hex_path, mode='L'):
    """
    Converts BMP image to HEX file.
    :param image_path: Path to the BMP image.
    :param output_hex_path: Path to save the output HEX file.
    :param mode: 'L' for grayscale (8-bit), 'RGB332' for 8-bit packed RGB.
    """
    img = Image.open(image_path).convert('RGB')
    width, height = img.size

    hex_lines = []

    for y in range(height):
        for x in range(width):
            r, g, b = img.getpixel((x, y))

            if mode == 'L':
                # Convert to grayscale using luminosity method
                gray = int(0.299*r + 0.587*g + 0.114*b)
                hex_lines.append(f"{gray:02X}")
            elif mode == 'RGB332':
                # Convert RGB to 3:3:2 (R:G:B) packed 8-bit format
                r3 = (r >> 5) & 0x07
                g3 = (g >> 5) & 0x07
                b2 = (b >> 6) & 0x03
                rgb332 = (r3 << 5) | (g3 << 2) | b2
                hex_lines.append(f"{rgb332:02X}")
            else:
                raise ValueError("Unsupported mode. Use 'L' or 'RGB332'.")

    with open(output_hex_path, 'w') as f:
        for line in hex_lines:
            f.write(line + '\n')

    print(f"HEX file written to {output_hex_path}")
