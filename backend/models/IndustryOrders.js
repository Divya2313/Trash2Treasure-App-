const mongoose = require('mongoose');

const industryOrderSchema = new mongoose.Schema({
  selectedWaste: Object,
  address: String,
  city: String,
  state: String,
  zipCode: String,
  date: String,
  time: String,
  location: String,
  status: { type: String, default: 'Pending' },
  createdAt: { type: Date, default: Date.now }
});

const IndustryOrder = mongoose.model('IndustryOrder', industryOrderSchema, 'IndustryOrdersCollection');

module.exports = IndustryOrder;
