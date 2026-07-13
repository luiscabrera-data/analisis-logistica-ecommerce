# Análisis de Eficiencia Logística — E-commerce

Análisis de datos aplicado a las operaciones logísticas de una empresa de e-commerce, con foco en identificar causas de retrasos, cancelaciones y variación de costos de envío entre almacenes.

## Contexto del Problema

La empresa reportó quejas de clientes por retrasos en sus pedidos y pedidos cancelados sin causa clara, además de sospechar diferencias de costo entre sus almacenes sin ver diferencias en el servicio. El objetivo fue identificar la causa raíz mediante análisis de datos y proponer recomendaciones accionables.

## Stack Técnico

- **Python (Pandas)** — Profiling y limpieza de datos
- **SQL Server** — Análisis y respuesta a preguntas de negocio
- **Power BI** — Dashboard ejecutivo de 3 páginas

## Estructura del Repositorio

```
├── Data/
│   ├── Raw/           # Datos originales sin procesar (4 archivos CSV)
│   └── Clean/          # Datos limpios y validados
├── Notebooks/          # 01_Profiling, 02_Data_Cleaning, 03_Eda_Logistica
├── SQL/                 # Consultas de negocio (7 preguntas clave)
├── PowerBI/             # Dashboard (.pbix)
└── Docs/                 # Documentación completa del proyecto
```

## Proceso

1. **Profiling (Python)** — Auditoría de calidad de datos: duplicados, nulos, formatos de fecha inconsistentes, outliers en costos de envío
2. **Limpieza (Python)** — Normalización de fechas, categorías y textos; conservación de valores nulos justificados (ej. pedidos sin fecha de entrega por estar aún en tránsito)
3. **Análisis (SQL Server)** — 7 consultas de negocio respondiendo preguntas clave sobre cancelaciones, retrasos, costos y evolución temporal
4. **Visualización (Power BI)** — Dashboard con KPIs de retraso, cancelación, costo promedio y evolución mensual

## Hallazgos Principales

- **Costo de envío uniforme entre almacenes** (S/ 19-22 en promedio) una vez excluidos 8 registros con valores atípicos de S/ 10,000 (errores de carga)
- **Tasa de retraso general: 7.5%**, por encima del umbral saludable del 5% en logística e-commerce
- **Lima concentra el 50% de las cancelaciones**, mientras que **Arequipa concentra el 50% de los retrasos** — dos problemas distintos con causas probablemente distintas
- **Reducción del 37.5% en incidentes** de 2025 a 2026, indicando una tendencia operativa positiva

## Nota

Este proyecto utiliza un dataset simulado con problemas de calidad de datos intencionales (fechas en múltiples formatos, valores nulos, outliers, duplicados) para replicar condiciones reales de trabajo con datos de producción.
