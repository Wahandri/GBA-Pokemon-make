from PIL import Image
import os

SPECIES = ["gorda", "charly"]

def fix_image_to_indexed(png_path, size=None):
    # Abre, quita alfa (rellena fondo), indexa a 16 colores y guarda el PNG indexado
    img = Image.open(png_path)
    # Quita alfa si la hay
    if img.mode in ("RGBA", "LA"):
        bg = Image.new("RGBA", img.size, (0, 0, 0, 0))
        bg.paste(img, mask=img.split()[-1])  # conservar transparencias
        # Rellena transparencias con el color 0 (negro); el negro acabará en la paleta y será index 0
        rgb = Image.new("RGB", img.size, (0, 0, 0))
        rgb.paste(bg, mask=None)
        img = rgb
    else:
        img = img.convert("RGB")

    # Ajusta a tamaño fijo si se pide (por ejemplo 64x64 para front/back, 32x32 para icon)
    if size is not None:
        # Amplía lienzo centrado sin deformar
        canvas = Image.new("RGB", size, (0, 0, 0))  # negro como fondo (será índice 0)
        x = (size[0] - img.width) // 2
        y = (size[1] - img.height) // 2
        canvas.paste(img, (x, y))
        img = canvas

    # Indexa a 16 colores
    img_indexed = img.convert("P", palette=Image.ADAPTIVE, colors=16)
    img_indexed.save(png_path, optimize=False)  # ¡IMPORTANTE! Guardar el PNG indexado

    # Devuelve la paleta (48 valores RGB)
    pal = img_indexed.getpalette()[:48]
    return pal

def write_jasc_pal(pal, out_path):
    with open(out_path, "w") as f:
        f.write("JASC-PAL\n0100\n16\n")
        for i in range(0, len(pal), 3):
            r, g, b = pal[i:i+3]
            f.write(f"{r} {g} {b}\n")

def process_species(sp):
    base = f"graphics/pokemon/{sp}"

    # 1) FRONT (64x64)
    front = os.path.join(base, "front.png")
    if os.path.exists(front):
        pal = fix_image_to_indexed(front, size=(64, 64))
        write_jasc_pal(pal, os.path.join(base, "normal.pal"))
        # shiny temporal = igual que normal
        with open(os.path.join(base, "normal.pal")) as f:
            open(os.path.join(base, "shiny.pal"), "w").write(f.read())
        print(f"✓ {sp}: front indexado y paletas normal/shiny generadas")

    # 2) BACK (64x64)
    back = os.path.join(base, "back.png")
    if os.path.exists(back):
        fix_image_to_indexed(back, size=(64, 64))
        print(f"✓ {sp}: back indexado")

    # 3) ICON (32x32)
    icon = os.path.join(base, "icon.png")
    if os.path.exists(icon):
        fix_image_to_indexed(icon, size=(32, 32))
        print(f"✓ {sp}: icon indexado")

    # 4) FOOTPRINT (16x16 recomendado, monocromo vale)
    fp = os.path.join(base, "footprint.png")
    if os.path.exists(fp):
        fix_image_to_indexed(fp, size=(16, 16))
        print(f"✓ {sp}: footprint indexado")

def main():
    for sp in SPECIES:
        process_species(sp)

if __name__ == "__main__":
    main()

