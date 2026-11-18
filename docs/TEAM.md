# Equipo y fases

Registro de responsables, entregas y validaciones. Los nombres describen roles de agentes, no personas. Las fases documentales no equivalen a una app compilada ni a una revisión de tiendas.

| Fase | Responsable | Entrega | Estado |
|---|---|---|---|
| 0. Marca | Agente de marca/UI | [BRAND.md](BRAND.md), [DESIGN.md](DESIGN.md), `assets/branding/tempo-mark.svg` y PNG opaco de 1024 × 1024 | Documentación y concepto entregados; nombre Tempo provisional. Verificaciones de marca, dominios y handles no son una autorización legal ni un registro. |
| 1. Análisis funcional | Agente técnico + REA MCP | [FEATURES.md](FEATURES.md), referencias a las fichas públicas y criterios de aceptación por función | Validada documentalmente el 18-11-2026. Se usaron capturas de página pública con idioma es-ES; no se descargó ni examinó IPA/APK, código o recursos de la app de referencia. |
| 2. Arquitectura | Agente de arquitectura | [ARCHITECTURE.md](ARCHITECTURE.md) | Propuesta entregada: Flutter, Riverpod, Hive CE, reloj monotónico nativo; falta implementarla y verificarla. |
| 3. Diseño | Agente de marca/UI | [DESIGN.md](DESIGN.md) | Direcciones originales y dirección recomendada documentadas; falta integrarlas en pantallas Flutter y validar accesibilidad con dispositivos. |
| 4. Implementación | Agente técnico principal | Código Flutter, persistencia, temporizador, plantillas, historial y ajustes | Pendiente. |
| 5. QA y seguridad | Agente QA/seguridad | [QA_SECURITY.md](QA_SECURITY.md) | Plan de pruebas y seguridad entregado; ningún caso se considera ejecutado por el mero hecho de estar especificado. |
| 6. Entornos | Agente de arquitectura + agente técnico | Sección de compilación en [ARCHITECTURE.md](ARCHITECTURE.md) | Instrucciones propuestas. La carpeta de trabajo está en Windows, sin Xcode, por lo que el simulador iOS y el archivo/IPA requieren un Mac. La firma requiere Team ID/certificado; la clave Android requiere acordarse y configurarse fuera de Git. |
| 7. Publicación y privacidad | Agente de tiendas/privacidad | [STORE_LISTING.md](STORE_LISTING.md), [PRIVACY.md](PRIVACY.md) | Borradores entregados; capturas reales, declaraciones de datos y textos de privacidad se deben verificar contra el artefacto final antes de enviar. |
| Documentación | Agente de documentación | [README.md](../README.md), [CHANGELOG.md](../CHANGELOG.md), este registro | Preparación entregada; actualizar estado tras implementar y ejecutar verificaciones. |

## Evidencia de análisis REA

- App Store: `ev_f52e45112a17f40d036d76b6bc8b3cf4617c0a500dadf43c37f5882ce7e03b6c`.
- Google Play: `ev_d3a90ca68da6d9f836fac4bd2f71a62594aa6c7f8401e6fb696a9192a10e37d2`.
- Entorno de captura: Chromium 157, idioma `es-ES`, páginas públicas de las tiendas, escenario de espera y captura de DOM/accesibilidad/pantalla. Los artefactos promocionales no se incorporaron al proyecto.

## Validación por fases

1. **Análisis:** validado contra las fuentes públicas; cada grupo de funciones distingue evidencia observada de requisitos de Tempo y de capacidades no confirmadas.
2. **Arquitectura:** propuesta revisada con un reloj nativo que avanza durante la suspensión del dispositivo; implementación pendiente.
3. **Diseño:** concepto original entregado; validación visual en la app pendiente.
4. **Implementación y pruebas:** pendientes.
5. **Seguridad en artefactos:** pendiente de compilar y auditar dependencias/permisos finales.
6. **Pruebas iOS:** pendiente de un entorno macOS/Xcode.
7. **Publicación:** pendiente de datos del titular, URL pública de privacidad, cuentas de tienda, revisión final de nombre y artefactos definitivos.
