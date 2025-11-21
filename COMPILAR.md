# Cómo Compilar tu ROM de Pokémon

Esta guía te ayudará a compilar tu ROM de Pokémon para Game Boy Advance.

## Requisitos Previos

Antes de compilar, necesitas tener instalado:
- Git
- Compilador ARM (arm-none-eabi)
- Herramientas de construcción
- Librerías de desarrollo

## Instalación de Dependencias

### En Ubuntu/Debian/WSL

Abre una terminal y ejecuta el siguiente comando:

```bash
sudo apt install build-essential binutils-arm-none-eabi gcc-arm-none-eabi libnewlib-arm-none-eabi git libpng-dev python3
```

### En Windows

Se recomienda usar **WSL2** (Windows Subsystem for Linux) para compilar. 

1. Instala WSL2 siguiendo las [instrucciones de Microsoft](https://docs.microsoft.com/es-es/windows/wsl/install)
2. Una vez instalado WSL2, abre Ubuntu y ejecuta el comando de arriba

Para más detalles, consulta: [docs/install/windows/WSL.md](docs/install/windows/WSL.md)

### En macOS

Consulta las instrucciones específicas en: [docs/install/mac/MAC_OS.md](docs/install/mac/MAC_OS.md)

### En Arch Linux

```bash
sudo pacman -S base-devel arm-none-eabi-binutils arm-none-eabi-gcc arm-none-eabi-newlib git libpng python3
```

Para más detalles: [docs/install/linux/ARCH_LINUX.md](docs/install/linux/ARCH_LINUX.md)

## Compilación

Una vez que tengas todas las dependencias instaladas:

1. Navega al directorio del proyecto:
   ```bash
   cd GBA-Pokemon-make
   ```

2. Compila el proyecto:
   ```bash
   make
   ```

3. Para compilar más rápido usando múltiples núcleos:
   ```bash
   make -j$(nproc)
   ```
   En macOS usa:
   ```bash
   make -j$(sysctl -n hw.ncpu)
   ```

4. Si todo funciona correctamente, verás algo similar a esto al final:
   ```
   Memory region         Used Size  Region Size  %age Used
              EWRAM:      230028 B       256 KB     87.75%
              IWRAM:       28684 B        32 KB     87.54%
                ROM:    24870364 B        32 MB     74.12%
   ```

5. Tu ROM compilada estará lista en el archivo: **`pokeemerald.gba`**

## Compilación con Información de Depuración

Para compilar con símbolos de depuración:

```bash
make debug
```

## Solución de Problemas

### Error: "arm-none-eabi-gcc: command not found"

Esto significa que no tienes instalado el compilador ARM. Instala las dependencias según tu sistema operativo (ver arriba).

### Error: "png.h: No such file or directory"

Falta la librería libpng. Instálala:
```bash
sudo apt install libpng-dev
```

### La compilación es muy lenta

Usa compilación paralela con `make -j$(nproc)` en lugar de solo `make`.

## Probar tu ROM

Puedes probar tu ROM usando un emulador como:
- [mGBA](https://mgba.io/) (recomendado para desarrollo)
- VBA (Visual Boy Advance)
- En hardware real usando un flashcart

## Documentación Adicional

- [README.md](README.md) - Información general del proyecto
- [INSTALL.md](INSTALL.md) - Instrucciones de instalación detalladas (en inglés)
- [FEATURES.md](FEATURES.md) - Lista de características
- [Documentación completa](https://rh-hideout.github.io/pokeemerald-expansion/) (en inglés)

## Comunidad y Soporte

Si necesitas ayuda, puedes:
- Unirte al [Discord de ROM Hacking Hideout](https://discord.gg/6CzjAG6GZk)
- Consultar las guías en la carpeta `docs/`
- Revisar los [tutoriales](docs/tutorials/) disponibles

## Actualizar el Proyecto

Para obtener las últimas actualizaciones:

```bash
git pull
```

Después de actualizar, recompila:

```bash
make clean
make -j$(nproc)
```

---

**¡Importante!** Este proyecto está basado en [pokeemerald-expansion](https://github.com/rh-hideout/pokeemerald-expansion/). Si lo usas en tu proyecto, por favor da crédito a RHH (Rom Hacking Hideout).
