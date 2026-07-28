// Server backend NodeJS + Express + Mongoose para YOBS - Catálogo de Servicios Laborales
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

// Cadena de conexión MongoDB
const MONGO_URI = process.env.MONGO_URI || "mongodb+srv://manuelrosadoochoa_db_user:sy7ZHQK5MbOidvtt@cluster0.qfiq5ym.mongodb.net/yobs_db?retryWrites=true&w=majority";

// Conexión a MongoDB Atlas / Local
mongoose.connect(MONGO_URI)
  .then(() => console.log('✅ Conectado exitosamente a MongoDB Database (yobs_db)'))
  .catch(err => console.error('❌ Error conectando a MongoDB:', err));

// --- SCHEMAS MONGOOSE ---

// Schema de Trabajador
const WorkerSchema = new mongoose.Schema({
  workerId: { type: String, required: true, unique: true },
  name: { type: String, required: true },
  mainTrade: { type: String, required: true },
  categoryId: { type: String, required: true },
  rating: { type: Number, default: 5.0 },
  totalJobs: { type: Number, default: 0 },
  experienceYears: { type: Number, default: 1 },
  hourlyRate: { type: Number, required: true },
  bio: String,
  certifications: [String],
  workPhotos: [String],
  isAvailable: { type: Boolean, default: true }
});

// Schema de Solicitud de Trabajo
const JobRequestSchema = new mongoose.Schema({
  requestId: { type: String, required: true, unique: true },
  serviceTitle: { type: String, required: true },
  workerName: String,
  clientName: String,
  date: { type: Date, default: Date.now },
  address: String,
  description: String,
  estimatedCost: Number,
  status: { type: String, enum: ['pendiente', 'enProceso', 'finalizado', 'cancelado'], default: 'pendiente' },
  paymentMethod: String,
  isPaid: { type: Boolean, default: false }
});

const Worker = mongoose.model('Worker', WorkerSchema);
const JobRequest = mongoose.model('JobRequest', JobRequestSchema);

// --- ENDPOINTS REST API ---

// 1. Obtener todos los trabajadores
app.get('/api/workers', async (req, res) => {
  try {
    const workers = await Worker.find();
    res.json(workers);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 2. Crear un nuevo trabajador
app.post('/api/workers', async (req, res) => {
  try {
    const newWorker = new Worker(req.body);
    await newWorker.save();
    res.status(201).json(newWorker);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// 3. Obtener solicitudes de empleo
app.get('/api/requests', async (req, res) => {
  try {
    const requests = await JobRequest.find();
    res.json(requests);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 4. Crear nueva solicitud de empleo
app.post('/api/requests', async (req, res) => {
  try {
    const newReq = new JobRequest(req.body);
    await newReq.save();
    res.status(201).json(newReq);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// 5. Actualizar estado de solicitud
app.patch('/api/requests/:id/status', async (req, res) => {
  try {
    const { status } = req.body;
    const updated = await JobRequest.findOneAndUpdate(
      { requestId: req.params.id },
      { status },
      { new: true }
    );
    res.json(updated);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// Schema para Pedidos (Orders)
const OrderSchema = new mongoose.Schema({
  orderId: { type: String, required: true, unique: true },
  serviceTitle: String,
  categoryId: String,
  workerId: String,
  workerName: String,
  workerTrade: String,
  clientName: String,
  clientPhone: String,
  orderDate: { type: Date, default: Date.now },
  serviceAddress: String,
  serviceDescription: String,
  estimatedCost: Number,
  hourlyRate: Number,
  estimatedHours: Number,
  status: { type: String, enum: ['pendiente', 'enProceso', 'finalizado', 'cancelado'], default: 'pendiente' },
  paymentMethod: String,
  isPaid: { type: Boolean, default: true },
  receiptNumber: String,
  completedAt: Date
}, { timestamps: true });

const Order = mongoose.model('Order', OrderSchema);

// 6. Crear un nuevo pedido en MongoDB
app.post('/api/orders', async (req, res) => {
  try {
    const newOrder = new Order(req.body);
    await newOrder.save();
    res.status(201).json(newOrder);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// 7. Obtener pedidos por cliente
app.get('/api/orders/client/:clientName', async (req, res) => {
  try {
    const orders = await Order.find({ clientName: req.params.clientName }).sort({ createdAt: -1 });
    res.json(orders);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 8. Actualizar estado de un pedido
app.patch('/api/orders/:orderId/status', async (req, res) => {
  try {
    const { status } = req.body;
    const updated = await Order.findOneAndUpdate(
      { orderId: req.params.orderId },
      { status, completedAt: status === 'finalizado' ? new Date() : null },
      { new: true }
    );
    res.json(updated);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Servidor backend YOBS escuchando en http://localhost:${PORT}`);
});
