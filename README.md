# Entorno reproducible TensorFlow + Jupyter en Apple Silicon (GPU) - como un contenedor pero sin Docker

## Intención del repositorio

Este repositorio proporciona un entorno de desarrollo reproducible para proyectos de Deep Learning basados en Jupyter Notebooks que:
* funciona **nativamente en macOS sobre Apple Silicon (M1, M2, M3, ...)**
* permite **usar la GPU del chip Apple** a través de **TensorFlow + Metal**
* **no interfiere** con ninguna instalación global de Python existente (pyenv, conda, system Python, etc.)
* sigue la **filosofía de contenedores**, aunque no usa Docker (por las limitaciones de GPU en macOS)
* puede lanzarse y usarse **directamente desde VS Code**, sin tocar el shell del sistema

La idea central es:

> Un entorno autocontenido, reproducible y desechable, como un contenedor, pero compatible con la GPU de Apple Silicon.

⸻

## Estructura del repositorio

```
.
├── environment.yml        # Definición del entorno TensorFlow Apple
├── bootstrap.sh           # Crea el entorno de forma local y autocontenida
├── run-jupyter.sh         # Lanza Jupyter usando ese entorno
├── env/
│   └── apple/             # Entorno micromamba (no global)
├── mamba/
│   └── micromamba         # Binario micromamba local al proyecto
├── notebooks/
│   └── test-notebook.ipynb
├── .vscode/
│   ├── tasks.json         # Tareas de VS Code
│   └── settings.json      # Configuración de Python/Jupyter
└── README.md
```

Nada fuera de este directorio se ve afectado.

⸻

## Dependencias y entorno

El entorno se define en environment.yml y se crea usando micromamba, descargado localmente por el propio proyecto.

Incluye:
* Python 3.10
* TensorFlow 2.11
* tensorflow-metal (backend GPU para Apple Silicon)
* JupyterLab
* dependencias científicas habituales (numpy, pandas, matplotlib)

El entorno:
* **no se registra globalmente**
* **no se activa en la shell**
* se usa **sólo cuando los scripts del proyecto lo invocan**

⸻

## Cómo usar el repositorio

### 1. Abre el proyecto en VS Code

Abre la carpeta del repositorio en VS Code. No es necesario configurar nada en tu terminal ni activar entornos manualmente.


### 2. Crea el entorno (una sola vez)

Desde VS Code:

1.	Cmd + Shift + P
2.	**Run Task &rarr; Bootstrap TensorFlow Apple env**

Esto ejecuta `bootstrap.sh`, que:
* descarga micromamba en el proyecto
* crea el entorno en `./env/apple`
* instala todas las dependencias

Si el entorno ya existe, no se vuelve a crear.

### 3. Lanza Jupyter Server

Desde VS Code:
1.	Cmd + Shift + P
2.	**Run Task &rarr; Run Jupyter (Apple GPU)**

Esto lanza un **Jupyter Lab local**, pero **usando exclusivamente el Python del entorno del proyecto**.

La salida del terminal mostrará una URL similar a:
```
http://localhost:8888/lab?token=...
```

El servidor queda corriendo mientras la tarea esté activa.

⸻

### 4. Usa Jupyter Notebooks desde VS Code

Opción recomendada: conectar VS Code al servidor lanzado
1.	Abre un notebook (v.g. `test-notebook.ipynb` que viene incluido en este repo) en VS Code
2.	En la esquina superior derecha de la ventana de edición, presiona donde dice **"Select Kernel"**
3.	Elige:
“Existing Jupyter Server”
4.	Pega la URL del servidor que lanzó la tarea

A partir de ese momento:
* el notebook se ejecuta **en ese servidor**
* usa **el entorno TensorFlow Apple**
* tiene **acceso a la GPU**

⸻

### 5. Verifica que la GPU está activa

En cualquier celda del notebook:
```python
import tensorflow as tf

tf.config.list_physical_devices("GPU")
```

La salida esperada es algo similar a:
```
[PhysicalDevice(name='/physical_device:GPU:0', device_type='GPU')]
```

Si aparece una GPU listada, TensorFlow está usando Metal correctamente.

⸻

## Desinstalación

Eliminar el entorno es tan simple como:
```shell
rm -rf env mamba
```


⸻

## Resumen

Este repositorio ofrece:
* TensorFlow + GPU en Apple Silicon
* Jupyter Notebooks desde VS Code
* entorno reproducible y autocontenido
* cero impacto en el sistema

Una solución práctica y realista a las limitaciones actuales de macOS para ML.
