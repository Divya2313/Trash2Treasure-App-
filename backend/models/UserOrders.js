const mongoose = require('mongoose');

const orderSchema = new mongoose.Schema({
  selectedWaste: Object,
  address: String,
  city: String,
  state: String,
  zip: String,
  liveLocation: String,
  status: { type: String, default: "Pending" }, // Add status
  createdAt: { type: Date, default: Date.now } // Add createdAt
});

const Order = mongoose.model('Order', orderSchema, 'UserOrdersCollection');

module.exports = Order;
