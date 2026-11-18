# Diseño de Tempo: Workout Timer

## Criterios de diseño

La interfaz debe servir durante una sesión con el teléfono apoyado lejos o sostenido con las manos sudadas. La prioridad visual es el tiempo restante, luego la fase y la ronda. Las acciones de mayor frecuencia ocupan controles amplios y separados; los ajustes menos frecuentes quedan fuera de la pantalla activa.

La reseña pública consultada en la ficha de Google Play critica que una actualización redujo la legibilidad y recargó los controles. Lo tomamos como señal de riesgo de uso durante una sesión, no como modelo visual. Todo el diseño y las etiquetas de Tempo son originales.

## Tres direcciones originales

### A. Pulso mineral — seleccionada

- **Paleta:** tinta #14201E, marfil #F6F4ED, turquesa #48C8B0, verde #145A50, coral oscuro #B94735 y ámbar #FFB25C.
- **Tipografía:** Manrope (SIL Open Font License), con cifras tabulares para tiempo y pesos 400–800 para escalado.
- **Iconografía:** símbolos lineales geométricos propios. El logotipo usa un ciclo abierto y tres bloques escalonados, sin agujas ni campana.
- **Sensación:** enfocada, cálida y deportiva sin exceso de energía visual.
- **Contraste medido para colores de texto principales:** verde #145A50 sobre marfil #F6F4ED: 7,32:1; coral #B94735 sobre marfil: 4,75:1; turquesa #48C8B0 sobre tinta #14201E: 8,10:1; marfil sobre tinta: 15,20:1. Valores calculados con luminancia relativa sRGB; las combinaciones de texto normal deben mantenerse por encima de 4,5:1 y las de texto grande/iconos esenciales por encima de 3:1.

### B. Pista solar

- **Paleta:** azul tinta #15284A, arena #FFF7E8, amarillo #F2B544, rojo arcilla #C44838.
- **Tipografía:** Atkinson Hyperlegible para controles y números, con una sans geométrica para titulares.
- **Iconografía:** pictogramas gruesos de bloques y flechas de avance.
- **Sensación:** luminosa y accesible; apropiada para pantallas claras y espacios exteriores.
- **Coste:** el amarillo exige un color de texto oscuro y no puede ser el único indicador del estado.

### C. Noche de pista

- **Paleta:** carbón #101114, blanco suave #F3F3F2, lima #C4F24A, azul intenso #4EA5FF.
- **Tipografía:** Space Grotesk para titulares y una sans neutra para datos.
- **Iconografía:** formas compactas de alto contraste, con estados codificados por forma además del color.
- **Sensación:** intensa y técnica, con una lectura rápida en un gimnasio oscuro.
- **Coste:** el neón puede fatigar la vista si domina la pantalla y limita una identidad amable en sesiones de baja intensidad.

## Elección

Se elige **Pulso mineral** porque destaca el temporizador, admite una lectura cómoda en temas claro y oscuro y conserva un tono calmado cuando se usa para cardio, movilidad o estiramientos. Ofrece un acento vivo sin convertir toda la pantalla en un aviso. El símbolo puede reducirse al icono y ampliarse al logotipo sin depender de una ilustración externa.

## Especificación de pantallas y controles

- **Pantalla activa:** título pequeño; etiqueta textual «TRABAJO», «DESCANSO» o «PREPARACIÓN»; cuenta atrás centrada y con cifras tabulares; progreso de ronda/serie; controles principales en fila inferior.
- **Controles primarios:** pausar/reanudar y saltar fase. Cada objetivo táctil debe medir al menos 56 × 56 dp/pt, con 12 dp/pt de separación y un área visible suficiente para no activar el control adyacente. Reiniciar queda separado de saltar y se confirma para evitar toques involuntarios.
- **Creación de rutina:** campos numéricos con unidades visibles, validación junto al campo y vista previa del número de intervalos y duración total.
- **Presets:** representan estructura y duración, no ilustraciones de ejercicios que la app no reconoce.
- **Historial:** resumen semanal accesible en lista además del gráfico; se puede entender sin distinguir colores.

## Accesibilidad y legibilidad

- Buscar conformidad WCAG 2.2 AA para texto y controles, contrastes indicados arriba y estados con texto/icono además de color.
- Respetar tamaño de texto del sistema hasta 200 %; usar diseños que permitan varias líneas y desplazamiento en listas/configuración. La cuenta atrás puede limitar su escalado solo si sigue legible y tiene una alternativa hablada.
- Proveer nombres accesibles descriptivos, orden de lectura lógico y valor de cuenta atrás con actualizaciones de accesibilidad limitadas para que VoiceOver/TalkBack no anuncien cada frame.
- Etiquetar botones con acción y contexto («Pausar entrenamiento», «Saltar descanso»), no con nombres ambiguos como «play».
- Verificar contraste en ambos temas, estado de enfoque, objetivos táctiles, orientación y tamaño de pantalla con VoiceOver/TalkBack y herramientas de auditoría.
- No codificar trabajo/descanso exclusivamente con turquesa/coral; añadir etiqueta y forma de progreso.

## Temas

| Elemento | Claro | Oscuro |
|---|---|---|
| Fondo | #F6F4ED | #14201E |
| Superficie | #FFFFFF | #1D2B28 |
| Texto principal | #14201E | #F6F4ED |
| Texto secundario | #40504C | #D0D9D5 |
| Acción primaria | #145A50 con texto blanco | #48C8B0 con texto #14201E |
| Descanso/alerta | #B94735 con icono/etiqueta | #FFB25C con icono/etiqueta |

No usar coral sobre fondo oscuro para texto pequeño; reservarlo para acentos no textuales o escoger marfil para el texto. Comprobar cada pareja real de texto/fondo en la implementación.

## Logo

El símbolo original en SVG está en assets/branding/tempo-mark.svg. Es una marca geométrica de ciclo abierto con segmentos escalonados. La variante PNG de tienda está en assets/branding/tempo-app-icon-1024.png, exportada a 1024 × 1024, con esquinas compuestas sobre tinta y sin canal alfa. Antes de publicar, comprobar las guías vigentes de cada tienda.
