from PIL import Image
import numpy as np

# Open image file
im = Image.open("minorcarmistake.jpg")

# Resize image and convert to grayscale
im = im.resize((120, 60))
im = im.convert("L")

# Define ASCII characters
ascii_chars = ["@", "#", "S", "%", "?", "*", "+", ";", ":", ","]

# Create an empty array for the ASCII art
ascii_art = np.zeros((60, 120))

# Iterate over each pixel in the image
for x in range(120):
    for y in range(60):
        # Get the pixel value
        pixel_value = im.getpixel((x, y))
        # Normalize the pixel value
        normalized_pixel_value = pixel_value / 255
        # Get the corresponding ASCII character
        ascii_char = ascii_chars[int(normalized_pixel_value * (len(ascii_chars) - 1))]
        # Insert the ASCII character into the ASCII art array
        ascii_art[y, x] = ascii_char

# Print the ASCII art
for row in ascii_art:
    print("".join(row))