# Lógica de uso y funcionamiento paso a paso de YOBS

## 1. Descripción general

**YOBS** es una aplicación móvil diseñada para conectar a clientes que necesitan un servicio con trabajadores que ofrecen distintos oficios, como electricidad, plomería, construcción, limpieza, pintura y mantenimiento.

La aplicación funcionará mediante dos tipos de usuario:

- **Cliente:** busca, compara y contrata trabajadores.
- **Trabajador:** publica sus servicios, recibe solicitudes y administra sus trabajos.

El flujo general de la aplicación será el siguiente:

```text
Bienvenida
   ↓
Registro o inicio de sesión
   ↓
Selección de rol
   ├── Cliente
   │      ↓
   │   Buscar trabajador
   │      ↓
   │   Enviar solicitud
   │      ↓
   │   Coordinar servicio
   │      ↓
   │   Finalizar y calificar
   │
   └── Trabajador
          ↓
       Configurar perfil laboral
          ↓
       Recibir solicitud
          ↓
       Aceptar o rechazar
          ↓
       Realizar servicio
          ↓
       Registrar finalización e ingreso
```

---

# 2. Actores del sistema

## 2.1 Cliente

El cliente podrá:

- Crear una cuenta.
- Iniciar sesión.
- Permitir el acceso a su ubicación.
- Buscar trabajadores cercanos.
- Filtrar trabajadores.
- Consultar perfiles, calificaciones y certificaciones.
- Enviar solicitudes de contratación.
- Comunicarse con el trabajador.
- Consultar el estado de sus solicitudes.
- Revisar su historial.
- Calificar servicios finalizados.
- Administrar su perfil y sus métodos de pago.

## 2.2 Trabajador

El trabajador podrá:

- Crear una cuenta.
- Iniciar sesión.
- Configurar su perfil laboral.
- Indicar categorías, servicios, tarifas y disponibilidad.
- Recibir solicitudes de clientes.
- Aceptar o rechazar trabajos.
- Comunicarse con clientes.
- Administrar su agenda.
- Marcar servicios como finalizados.
- Consultar su historial.
- Revisar sus calificaciones y reputación.
- Consultar sus ingresos.

---

# 3. Flujo inicial de la aplicación

## 3.1 Pantalla de bienvenida

1. El usuario abre la aplicación.
2. El sistema muestra el logotipo de YOBS y una breve explicación de su función.
3. Se presentan dos opciones:
   - **Crear cuenta**
   - **Iniciar sesión**
4. Si el usuario no tiene una cuenta, selecciona **Crear cuenta**.
5. Si ya está registrado, selecciona **Iniciar sesión**.

### Resultado esperado

El usuario comprende el propósito de la plataforma y elige la forma de acceso correspondiente.

---

## 3.2 Registro de usuario

1. El usuario selecciona **Crear cuenta**.
2. El sistema muestra un formulario con los siguientes campos:
   - Nombre completo.
   - Correo electrónico.
   - Contraseña.
   - Confirmación de contraseña.
3. El usuario captura sus datos.
4. El sistema valida que:
   - Ningún campo obligatorio esté vacío.
   - El correo tenga un formato válido.
   - El correo no se encuentre registrado.
   - La contraseña cumpla con la longitud mínima.
   - La contraseña y su confirmación coincidan.
5. Si los datos son correctos, el sistema crea la cuenta.
6. El sistema inicia la sesión automáticamente o dirige al usuario al inicio de sesión.
7. El usuario continúa a la pantalla de selección de rol.

### Posibles errores

- **Correo ya registrado:** mostrar un mensaje y ofrecer la opción de iniciar sesión.
- **Contraseñas diferentes:** solicitar que se vuelvan a escribir.
- **Datos incompletos:** resaltar los campos pendientes.
- **Falla de conexión:** conservar los datos escritos y permitir reintentar.

---

## 3.3 Inicio de sesión

1. El usuario selecciona **Iniciar sesión**.
2. Captura su correo y contraseña.
3. El sistema busca la cuenta registrada.
4. El sistema compara las credenciales.
5. Si son correctas, se crea una sesión.
6. El sistema identifica el rol del usuario.
7. El usuario es dirigido a su pantalla principal:
   - Inicio del cliente.
   - Panel del trabajador.

### Posibles errores

- Correo no registrado.
- Contraseña incorrecta.
- Cuenta deshabilitada.
- Falla de conexión.

El sistema deberá mostrar mensajes claros sin revelar información sensible.

---

## 3.4 Selección de rol

1. Después del registro, el sistema pregunta: **¿Cómo quieres usar YOBS?**
2. El usuario selecciona una opción:
   - **Buscar servicios como cliente.**
   - **Ofrecer servicios como trabajador.**
3. El sistema guarda el rol seleccionado.
4. La navegación y las funciones disponibles cambian de acuerdo con el rol.

### Regla principal

Un usuario no debe acceder a funciones que no correspondan con su rol. En una versión futura, se podría permitir cambiar o agregar un segundo rol desde la configuración.

---

# 4. Funcionamiento paso a paso para el cliente

## 4.1 Configuración inicial del cliente

1. El sistema solicita permiso para acceder a la ubicación.
2. Si el cliente acepta:
   - Se obtiene su ubicación aproximada.
   - Se muestran trabajadores cercanos en el mapa.
3. Si el cliente rechaza el permiso:
   - Puede escribir manualmente una colonia, municipio, código postal o dirección.
4. El cliente completa o verifica los datos de su perfil.

---

## 4.2 Pantalla de inicio del cliente

1. El cliente entra a la pantalla principal.
2. El sistema muestra:
   - Ubicación actual.
   - Barra de búsqueda.
   - Categorías de oficios.
   - Mapa de trabajadores disponibles.
   - Recomendaciones cercanas.
3. El cliente puede seleccionar una categoría, por ejemplo:
   - Electricidad.
   - Plomería.
   - Construcción.
   - Limpieza.
   - Pintura.
   - Mantenimiento.
4. El sistema actualiza la lista y el mapa con los trabajadores relacionados.

---

## 4.3 Búsqueda avanzada de trabajadores

1. El cliente escribe el servicio que necesita.
2. Selecciona una categoría.
3. Puede aplicar filtros como:
   - Distancia.
   - Calificación mínima.
   - Rango de precio.
   - Disponibilidad.
   - Trabajador verificado.
4. El sistema consulta los perfiles disponibles.
5. Se muestran únicamente los trabajadores que cumplen con los criterios.
6. Cada resultado debe presentar:
   - Nombre.
   - Fotografía.
   - Oficio o especialidad.
   - Calificación.
   - Distancia.
   - Tarifa aproximada.
   - Estado de disponibilidad.
7. El cliente selecciona un trabajador para abrir su perfil.

---

## 4.4 Consulta del perfil público del trabajador

1. El cliente abre el perfil del trabajador.
2. El sistema muestra:
   - Nombre y fotografía.
   - Descripción profesional.
   - Servicios disponibles.
   - Tarifas.
   - Experiencia.
   - Certificaciones.
   - Calificación promedio.
   - Comentarios de otros clientes.
   - Disponibilidad.
3. El cliente analiza la información.
4. Puede regresar a los resultados o seleccionar **Solicitar servicio**.

---

## 4.5 Envío de una solicitud de servicio

1. El cliente selecciona **Solicitar servicio**.
2. El sistema abre un formulario.
3. El cliente proporciona:
   - Tipo de servicio.
   - Descripción del problema.
   - Fecha solicitada.
   - Hora aproximada.
   - Dirección.
   - Nivel de urgencia.
   - Fotografías opcionales.
4. El sistema muestra un resumen.
5. El cliente confirma el envío.
6. Se crea una solicitud con estado **Pendiente**.
7. El trabajador recibe una notificación.
8. La solicitud aparece en la sección **Mis solicitudes** del cliente.

### Datos mínimos de la solicitud

```text
ID de solicitud
Cliente
Trabajador
Categoría
Descripción
Ubicación
Fecha y hora
Precio estimado
Estado
Fecha de creación
```

---

## 4.6 Seguimiento de solicitudes

El cliente podrá consultar las solicitudes enviadas y su estado.

### Estados sugeridos

- **Pendiente:** todavía no ha sido revisada por el trabajador.
- **Aceptada:** el trabajador aceptó realizar el servicio.
- **Rechazada:** el trabajador no puede realizar el servicio.
- **En conversación:** se están acordando detalles.
- **Confirmada:** ambas partes aceptaron fecha, precio y condiciones.
- **En proceso:** el trabajador está realizando el servicio.
- **Finalizada:** el trabajo fue completado.
- **Cancelada:** la solicitud fue cancelada.
- **Pendiente de calificación:** el servicio terminó, pero aún no ha sido evaluado.

### Comportamiento

1. El cliente entra en **Mis solicitudes**.
2. El sistema muestra cada solicitud con su estado.
3. El cliente selecciona una solicitud.
4. Puede consultar los detalles, abrir el chat o cancelarla cuando las reglas lo permitan.

---

## 4.7 Conversación con el trabajador

1. Cuando existe una solicitud, el sistema habilita un chat.
2. El cliente abre la sección **Conversaciones**.
3. Selecciona al trabajador.
4. Puede enviar:
   - Mensajes de texto.
   - Fotografías.
   - Ubicación.
   - Detalles adicionales.
5. Los mensajes quedan asociados a la solicitud.
6. El sistema registra fecha y hora de cada mensaje.
7. Ambos usuarios reciben notificaciones de mensajes nuevos.

### Regla de seguridad

El chat debe utilizarse para asuntos relacionados con el servicio. El sistema puede incluir opciones para bloquear o reportar conductas inapropiadas.

---

## 4.8 Confirmación del servicio

1. El trabajador acepta la solicitud.
2. Cliente y trabajador acuerdan:
   - Fecha.
   - Hora.
   - Alcance del trabajo.
   - Precio aproximado o definitivo.
3. El cliente confirma los datos.
4. El sistema cambia el estado a **Confirmada**.
5. El servicio se agrega:
   - A las solicitudes activas del cliente.
   - A la agenda del trabajador.
6. Ambos reciben una notificación de confirmación.

---

## 4.9 Inicio y finalización del servicio

1. En la fecha acordada, el trabajador puede marcar el trabajo como **En proceso**.
2. El cliente recibe una notificación.
3. Al terminar, el trabajador selecciona **Finalizar servicio**.
4. El sistema solicita:
   - Monto final.
   - Observaciones.
   - Evidencia opcional.
5. El cliente recibe una solicitud de confirmación.
6. Cuando el cliente confirma, el estado cambia a **Finalizada**.
7. La operación pasa al historial.
8. El sistema habilita la calificación.

### Manejo de desacuerdos

Si el cliente no está de acuerdo con la finalización, podrá reportar un problema y el servicio quedará en estado **En revisión**.

---

## 4.10 Calificación del servicio

1. El cliente entra en **Historial**.
2. El sistema muestra los servicios pendientes de calificar.
3. El cliente selecciona uno.
4. Asigna una calificación, por ejemplo, de 1 a 5 estrellas.
5. Puede escribir un comentario.
6. El sistema valida que solo se permita una calificación por servicio.
7. La evaluación se guarda.
8. Se actualiza la reputación del trabajador.
9. El servicio pasa a estado **Calificado**.

### Criterios opcionales

- Puntualidad.
- Calidad.
- Atención.
- Cumplimiento del precio.
- Limpieza o cuidado del área.

---

## 4.11 Perfil del cliente

1. El cliente abre la sección **Perfil**.
2. Puede consultar:
   - Datos personales.
   - Información de contacto.
   - Dirección.
   - Métodos de pago.
   - Historial de servicios.
3. Selecciona **Editar perfil**.
4. Modifica la información permitida.
5. El sistema valida y guarda los cambios.

---

# 5. Funcionamiento paso a paso para el trabajador

## 5.1 Configuración del perfil laboral

1. Después de seleccionar el rol de trabajador, el sistema solicita completar el perfil.
2. El trabajador registra:
   - Nombre profesional.
   - Fotografía.
   - Descripción.
   - Categorías de trabajo.
   - Servicios específicos.
   - Años de experiencia.
   - Tarifas.
   - Zona de cobertura.
   - Disponibilidad.
   - Certificaciones.
3. El sistema valida la información.
4. El trabajador guarda el perfil.
5. El perfil se publica y puede aparecer en las búsquedas de clientes.

### Regla de visibilidad

Un perfil incompleto puede guardarse como borrador, pero no deberá mostrarse públicamente hasta cumplir con los datos mínimos.

---

## 5.2 Panel principal del trabajador

1. El trabajador inicia sesión.
2. El sistema muestra un resumen con:
   - Solicitudes nuevas.
   - Trabajos próximos.
   - Mensajes recientes.
   - Servicios en proceso.
   - Ingresos recientes.
3. El trabajador puede abrir cualquier solicitud para revisarla.

---

## 5.3 Recepción de una solicitud

1. Un cliente envía una solicitud.
2. El sistema notifica al trabajador.
3. La solicitud aparece en el panel con estado **Pendiente**.
4. El trabajador abre el detalle.
5. Revisa:
   - Servicio requerido.
   - Descripción.
   - Ubicación.
   - Fecha y hora.
   - Urgencia.
   - Fotografías.
   - Precio estimado.
6. El trabajador decide:
   - **Aceptar.**
   - **Rechazar.**
   - **Solicitar más información.**

---

## 5.4 Aceptación o rechazo

### Si acepta

1. El trabajador selecciona **Aceptar**.
2. Puede confirmar o proponer:
   - Fecha.
   - Hora.
   - Precio.
3. El cliente recibe la respuesta.
4. La solicitud cambia a **Aceptada** o **En conversación**.
5. Cuando ambas partes confirman, cambia a **Confirmada**.
6. El trabajo se agrega a la agenda.

### Si rechaza

1. El trabajador selecciona **Rechazar**.
2. Puede indicar un motivo:
   - No disponible.
   - Fuera de zona.
   - Servicio no compatible.
   - Horario no disponible.
3. El sistema cambia el estado a **Rechazada**.
4. El cliente recibe una notificación.
5. El cliente puede buscar otro trabajador.

---

## 5.5 Administración de agenda

1. El trabajador abre la sección **Agenda**.
2. El sistema muestra sus trabajos por día, semana o mes.
3. Cada elemento indica:
   - Cliente.
   - Tipo de servicio.
   - Fecha y hora.
   - Dirección.
   - Estado.
   - Nivel de urgencia.
4. El sistema debe evitar que se confirmen dos servicios en el mismo horario.
5. El trabajador puede actualizar su disponibilidad.
6. Los cambios importantes generan una notificación para el cliente.

---

## 5.6 Comunicación con clientes

1. El trabajador abre **Conversaciones**.
2. Selecciona una solicitud.
3. Responde dudas y coordina detalles.
4. Puede recibir fotografías o ubicaciones.
5. El historial queda vinculado con el servicio.
6. Una conversación no debe eliminarse mientras el servicio esté activo o en revisión.

---

## 5.7 Ejecución y finalización del trabajo

1. El trabajador consulta su agenda.
2. Abre el servicio programado.
3. Selecciona **Iniciar servicio**.
4. El sistema cambia el estado a **En proceso**.
5. Al concluir, selecciona **Finalizar servicio**.
6. Registra:
   - Monto final.
   - Descripción del trabajo realizado.
   - Materiales utilizados, si aplica.
   - Fotografías opcionales.
7. El cliente confirma la finalización.
8. El sistema mueve el servicio al historial.
9. El ingreso se agrega al módulo financiero.

---

## 5.8 Historial y reputación

1. El trabajador abre **Historial y reputación**.
2. El sistema muestra:
   - Servicios finalizados.
   - Calificaciones recibidas.
   - Comentarios.
   - Promedio de reputación.
   - Número de trabajos completados.
3. El trabajador puede filtrar por fecha, categoría o calificación.
4. Al seleccionar un servicio, se abre su detalle.
5. La reputación actualizada se muestra en el perfil público.

### Cálculo sugerido de reputación

La calificación general puede obtenerse mediante el promedio de todas las evaluaciones válidas. En una versión posterior se pueden ponderar factores como puntualidad, calidad y número de servicios completados.

---

## 5.9 Detalle financiero

1. El trabajador abre la sección **Ingresos**.
2. El sistema consulta los servicios finalizados y cobrados.
3. Se muestran:
   - Total del mes.
   - Total semanal.
   - Número de servicios.
   - Promedio por servicio.
   - Lista de movimientos.
4. El trabajador selecciona una semana o un servicio.
5. El sistema muestra el detalle:
   - Cliente.
   - Fecha.
   - Servicio.
   - Monto.
   - Estado del pago.
6. La información ayuda al trabajador a evaluar su rendimiento económico.

---

# 6. Ciclo completo de una contratación

El ciclo principal de YOBS será el siguiente:

```text
1. Cliente busca un trabajador.
2. Cliente revisa el perfil.
3. Cliente envía una solicitud.
4. Trabajador recibe la solicitud.
5. Trabajador acepta, rechaza o pide información.
6. Cliente y trabajador conversan.
7. Ambas partes confirman fecha, precio y condiciones.
8. El trabajo se agrega a la agenda.
9. El trabajador inicia el servicio.
10. El trabajador marca el servicio como terminado.
11. El cliente confirma la finalización.
12. El sistema registra el ingreso.
13. El cliente califica al trabajador.
14. La reputación del trabajador se actualiza.
15. El servicio queda guardado en el historial.
```

---

# 7. Lógica de estados de una solicitud

```text
PENDIENTE
   ├── RECHAZADA
   ├── CANCELADA
   └── ACEPTADA
          ↓
     EN CONVERSACIÓN
          ↓
       CONFIRMADA
          ↓
       EN PROCESO
          ↓
       FINALIZADA
          ↓
 PENDIENTE DE CALIFICACIÓN
          ↓
       CALIFICADA
```

También podrá existir el estado **En revisión** cuando alguna de las partes reporte un problema.

### Reglas de cambio de estado

- Solo el trabajador puede aceptar o rechazar una solicitud.
- El cliente puede cancelar antes del inicio, de acuerdo con las políticas.
- Solo un servicio confirmado puede pasar a **En proceso**.
- Solo un servicio en proceso puede pasar a **Finalizado**.
- Solo el cliente que contrató puede calificar el servicio.
- Un servicio calificado no puede volver a calificarse.

---

# 8. Notificaciones del sistema

El sistema enviará notificaciones cuando ocurra alguno de estos eventos:

- Registro completado.
- Nueva solicitud recibida.
- Solicitud aceptada.
- Solicitud rechazada.
- Nuevo mensaje.
- Cambio de fecha u horario.
- Servicio próximo.
- Servicio iniciado.
- Servicio finalizado.
- Calificación pendiente.
- Nueva calificación recibida.
- Actualización importante de la cuenta.

Las notificaciones deberán dirigir al usuario a la pantalla relacionada con el evento.

---

# 9. Validaciones principales

## 9.1 Cuenta

- Correo único.
- Contraseña segura.
- Campos obligatorios completos.
- Sesión válida.
- Recuperación de contraseña.

## 9.2 Perfil del trabajador

- Al menos una categoría.
- Descripción mínima.
- Tarifa válida.
- Zona de servicio definida.
- Disponibilidad registrada.
- Certificaciones verificables cuando se muestren como oficiales.

## 9.3 Solicitud

- Cliente y trabajador existentes.
- Fecha válida.
- Dirección válida.
- Descripción obligatoria.
- Estado compatible con la acción solicitada.

## 9.4 Calificación

- Servicio finalizado.
- Cliente relacionado con el servicio.
- Una sola calificación por contratación.
- Valor dentro del rango permitido.

## 9.5 Ingresos

- Solo contar servicios finalizados y cobrados.
- Evitar registros duplicados.
- Conservar fecha, monto y referencia del servicio.

---

# 10. Seguridad y privacidad

La aplicación deberá considerar las siguientes medidas:

- Contraseñas almacenadas de forma segura.
- Sesiones con expiración.
- Protección de datos personales.
- Ubicación visible únicamente cuando sea necesaria.
- Restricción de funciones según el rol.
- Validación de archivos e imágenes.
- Opción para reportar usuarios.
- Registro de acciones importantes.
- No mostrar datos sensibles públicamente.
- Confirmación antes de eliminar o cancelar información.

---

# 11. Navegación sugerida

## 11.1 Menú del cliente

```text
Inicio
Buscar
Solicitudes
Mensajes
Historial
Perfil
```

## 11.2 Menú del trabajador

```text
Panel
Solicitudes
Agenda
Mensajes
Historial
Ingresos
Perfil
```

---

# 12. Datos principales que deberá manejar el sistema

## Usuario

- ID.
- Nombre.
- Correo.
- Contraseña protegida.
- Rol.
- Teléfono.
- Fotografía.
- Estado de cuenta.

## Perfil laboral

- ID del trabajador.
- Descripción.
- Categorías.
- Servicios.
- Tarifas.
- Experiencia.
- Certificaciones.
- Disponibilidad.
- Zona de cobertura.
- Calificación promedio.

## Solicitud

- ID.
- Cliente.
- Trabajador.
- Servicio.
- Descripción.
- Dirección.
- Ubicación.
- Fecha y hora.
- Precio.
- Estado.

## Mensaje

- ID.
- Solicitud.
- Emisor.
- Receptor.
- Contenido.
- Archivo opcional.
- Fecha y hora.

## Calificación

- ID.
- Servicio.
- Cliente.
- Trabajador.
- Puntuación.
- Comentario.
- Fecha.

## Ingreso

- ID.
- Trabajador.
- Servicio.
- Monto.
- Fecha.
- Estado de pago.

---

# 13. Alcance del MVP

La primera versión funcional deberá incluir como mínimo:

- Registro.
- Inicio de sesión.
- Selección de rol.
- Perfil de cliente y trabajador.
- Geolocalización.
- Categorías de servicios.
- Búsqueda y filtros.
- Solicitudes.
- Aceptación y rechazo.
- Conversaciones.
- Agenda.
- Historial.
- Calificaciones.
- Reputación.
- Consulta básica de ingresos.

Las siguientes funciones podrán agregarse después:

- Pagos electrónicos.
- Facturación.
- Beneficios laborales.
- Gestión de inventarios.
- Verificación avanzada de identidad.
- Sistema de disputas más completo.
- Suscripciones.
- Promociones.
- Panel administrativo avanzado.

---

# 14. Prueba y validación del MVP

Para validar el funcionamiento se propone realizar una prueba piloto.

## Pasos

1. Seleccionar una colonia o municipio.
2. Registrar un grupo pequeño de clientes y trabajadores.
3. Solicitar servicios reales o simulados.
4. Medir:
   - Número de registros.
   - Número de búsquedas.
   - Solicitudes enviadas.
   - Solicitudes aceptadas.
   - Servicios finalizados.
   - Tiempo de respuesta.
   - Calificación promedio.
   - Problemas reportados.
5. Entrevistar a los usuarios.
6. Identificar pantallas confusas.
7. Corregir errores.
8. Repetir la prueba.

---

# 15. Resultado esperado

YOBS permitirá que un cliente encuentre trabajadores cercanos, revise información confiable, solicite un servicio y dé seguimiento a todo el proceso desde la aplicación.

Al mismo tiempo, el trabajador podrá aumentar su visibilidad, recibir oportunidades de empleo, administrar su agenda, construir una reputación y consultar sus ingresos.

De esta forma, la plataforma busca mejorar la confianza, la organización y la transparencia en la contratación de trabajadores de oficios.
