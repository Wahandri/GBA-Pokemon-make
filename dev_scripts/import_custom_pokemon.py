#!/usr/bin/env python3
import os, sys, subprocess
from PIL import Image

# --- CONFIGURACIÓN BASE ---
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
GBAGFX = os.path.join(ROOT, "tools", "gbagfx", "gbagfx")

# --- FUNCIONES AUXILIARES ---

def ensure_tool():
    if not os.path.isfile(GBAGFX):
        print("❌ No se encontró gbagfx en:", GBAGFX)
        print("Ejecuta `make tools` para compilar las herramientas.")
        sys.exit(1)

def quantize_16(img: Image.Image) -> Image.Image:
    # Convierte la imagen a RGB y reduce a 16 colores sin dithering
    rgb = img.convert("RGB")
    return rgb.quantize(colors=16, method=2, dither=Image.NONE)

def fit_64(img: Image.Image) -> Image.Image:
    # Crea un lienzo de 64x64 y centra el sprite
    canvas = Image.new("RGBA", (64, 64), (0, 0, 0, 0))
    w, h = img.size
    scale = min(64 / max(1, w), 64 / max(1, h))
    new = img.resize((max(1, int(w * scale)), max(1, int(h * scale))), Image.NEAREST)
    x = (64 - new.size[0]) // 2
    y = (64 - new.size[1]) // 2
    canvas.paste(new, (x, y))
    return canvas

def write_png(path, im):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    im.save(path)

def run(cmd):
    print("•", " ".join(cmd))
    subprocess.check_call(cmd)

# --- PROCESADO PRINCIPAL ---

def build_mon(mon_name):
    src_dir = os.path.join(ROOT, "dev_assets", mon_name)
    out_dir = os.path.join(ROOT, "graphics", "pokemon", mon_name)
    os.makedirs(out_dir, exist_ok=True)

    # 1) Preparar front/back PNG indexados 16 col (misma paleta)
    front_rgb = Image.open(os.path.join(src_dir, "front.png"))
    back_rgb = Image.open(os.path.join(src_dir, "back.png"))

    front_64 = fit_64(front_rgb)
    back_64 = fit_64(back_rgb)

    # Generamos paleta a partir del front e igualamos el back
    front_q = quantize_16(front_64).convert("P")
    pal = front_q.getpalette()
    back_q = quantize_16(back_64).convert("P")
    back_q.putpalette(pal)

    tmp_dir = os.path.join(ROOT, "build", "custom_import", mon_name)
    os.makedirs(tmp_dir, exist_ok=True)
    tmp_front = os.path.join(tmp_dir, "front_indexed.png")
    tmp_back = os.path.join(tmp_dir, "back_indexed.png")
    write_png(tmp_front, front_q)
    write_png(tmp_back, back_q)

    # 2) Extraer paleta .pal (JASC) del front
    pal_path = os.path.join(tmp_dir, "normal.pal")
    with open(pal_path, "w") as f:
        f.write("JASC-PAL\n0100\n16\n")
        for i in range(16):
            r = pal[i * 3 + 0]
            g = pal[i * 3 + 1]
            b = pal[i * 3 + 2]
            f.write(f"{r} {g} {b}\n")

    # 3) Convertir a .4bpp.lz y .gbapal.lz con gbagfx
    run([GBAGFX, tmp_front, os.path.join(out_dir, "front.4bpp.lz")])
    run([GBAGFX, tmp_back, os.path.join(out_dir, "back.4bpp.lz")])
    run([GBAGFX, pal_path, os.path.join(out_dir, "normal.gbapal.lz")])

    print(f"✅ {mon_name}: front/back + paleta generados en {out_dir}")


# --- PUNTO DE ENTRADA ---

def main():
    ensure_tool()
    if len(sys.argv) < 2:
        print("Uso: python3 dev_scripts/import_custom_pokemon.py <nombre_pokemon>")
        sys.exit(1)
    for mon in sys.argv[1:]:
        build_mon(mon)

if __name__ == "__main__":
    main()
