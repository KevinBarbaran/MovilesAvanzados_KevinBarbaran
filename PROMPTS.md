# Prompts — Lab 03
## Docente: Juan Leon — Tecsup
## Herramienta: ChatGPT

---

## Ejercicio 6 — Gestión de notas

### Prompt (CTRFE):
* CONTEXTO: Soy estudiante de desarrollo iOS en Tecsup (Semana 3). Estamos aprendiendo el manejo de colecciones en Swift (Arrays, Diccionarios y Sets).
* TAREA: Crear un script que pida $N$ alumnos con su nombre y 3 notas en un diccionario `[String: [Double]]`. Debe calcular el promedio por alumno, clasificar con `switch` (Excelente, Bueno, Aprobado, Desaprobado), mostrar estadísticas generales (promedio general, nota más alta/baja, % de aprobados) y mostrar la lista ordenada por promedio de mayor a menor.
* RESTRICCIONES: Usar solo conceptos aprendidos en las Semanas 1 a 3. Incluir valores por defecto o simulación para que ejecute en Playgrounds/Xcode sin quedarse pausado en `readLine()`.
* FORMATO: Código Swift limpio con un comentario descriptivo en CADA línea de código.
* EJEMPLO:
  ```swift
  var registroAlumnos: [String: [Double]] = [:] // Diccionario para almacenar alumno y notas
