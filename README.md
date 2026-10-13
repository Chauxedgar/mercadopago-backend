# 💳 Integración de Mercado Pago (Checkout Pro) con Node.js y Flutter

Proyecto académico de ingeniería diseñado para implementar una pasarela de pagos completa y segura utilizando **Mercado Pago Checkout Pro**, un servidor backend en **Node.js (Express)**, una interfaz cliente en **Flutter** y un túnel HTTPS con **Ngrok** para la gestión de redirecciones en entorno de pruebas (Sandbox).

---

## 🚀 Tecnologías y Herramientas Utilizadas

* **Backend:** Node.js, Express, Cors.
* **Pasarela de Pagos:** SDK Oficial de Mercado Pago (`mercadopago`).
* **Cliente:** Flutter (con soporte para peticiones HTTP y redirección web).
* **Seguridad y Redes:** Ngrok (Túnel HTTPS para bypass de restricciones `localhost`).
* **Entorno:** Sandbox (Pruebas con credenciales de desarrollo).

---

## 📂 Estructura del Repositorio

```text
mercadopago-integration/
│
├── mercadopago-backend/         # Servidor Node.js
│   ├── node_modules/
│   ├── index.js                 # Lógica principal, rutas y SDK de MP
│   ├── package.json
│   └── package-lock.json
│
└── app_mercado_pago/            # Cliente Flutter (Opcional según estructura)
    ├── lib/
    ├── android/                 # Configuración de permisos (AndroidManifest.xml)
    └── pubspec.yaml
