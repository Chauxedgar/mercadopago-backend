const express = require('express');
const cors = require('cors');
const { MercadoPagoConfig, Preference } = require('mercadopago');

// Configura tu Access Token de PRUEBA
const client = new MercadoPagoConfig({ 
  accessToken: 'APP_USR-3055598923469470-101222-dbd2e6584e9a84ee3f33e6974ef6acae-3761183938' 
});

const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

// Ruta de prueba principal
app.get('/', (req, res) => {
  res.send('Backend de Mercado Pago funcionando correctamente 🚀');
});

// Rutas para capturar los estados de la redirección de Mercado Pago con datos dinámicos
app.get('/success', (req, res) => {
  const paymentId = req.query.collection_id || req.query.payment_id || 'Simulación Sandbox';
  const status = req.query.status || 'aprobado';

  res.send(`
    <div style="font-family: Arial; text-align: center; margin-top: 50px; color: green;">
      <h1>¡Pago Aprobado con Éxito! 🎉</h1>
      <p>La transacción se ha completado correctamente en el modo Sandbox.</p>
      <div style="background: #f4f4f4; display: inline-block; padding: 20px; border-radius: 8px; margin-top: 20px; text-align: left; color: #333;">
        <p><strong>ID de Transacción / Pago:</strong> ${paymentId}</p>
        <p><strong>Estado del Pago:</strong> ${status}</p>
        <p><strong>Fecha:</strong> ${new Date().toLocaleString()}</p>
      </div>
      <br><br>
      <a href="http://localhost:3000/">Volver al inicio</a>
    </div>
  `);
});

app.get('/failure', (req, res) => {
  res.send(`
    <div style="font-family: Arial; text-align: center; margin-top: 50px; color: red;">
      <h1>¡El pago ha fallado o fue rechazado! ❌</h1>
      <p>Hubo un problema al procesar tu transacción de prueba.</p>
      <a href="http://localhost:3000/">Intentar de nuevo</a>
    </div>
  `);
});

app.get('/pending', (req, res) => {
  res.send(`
    <div style="font-family: Arial; text-align: center; margin-top: 50px; color: orange;">
      <h1>¡Pago Pendiente! ⏳</h1>
      <p>Tu pago está en proceso de verificación (ej. pago en efectivo pendiente).</p>
      <a href="http://localhost:3000/">Volver al inicio</a>
    </div>
  `);
});

// Ruta para crear la preferencia de pago apuntando al túnel de Ngrok
app.post('/create_preference', async (req, res) => {
  try {
    const preference = new Preference(client);
    
    const result = await preference.create({
      body: {
        items: [
          {
            title: 'Producto de Prueba Universitario',
            quantity: 1,
            unit_price: 50000
          }
        ],
        back_urls: {
          success: "https://kabob-subscript-partition.ngrok-free.dev/success",
          failure: "https://kabob-subscript-partition.ngrok-free.dev/failure",
          pending: "https://kabob-subscript-partition.ngrok-free.dev/pending"
        },
        auto_return: "approved",
      }
    });

    res.json({
      id: result.id,
      init_point: result.init_point,
      sandbox_init_point: result.sandbox_init_point
    });

  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al crear la preferencia de pago" });
  }
});

app.listen(port, () => {
  console.log(`Servidor corriendo en http://localhost:${port}`);
});