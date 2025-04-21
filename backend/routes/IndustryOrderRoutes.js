const express = require("express");
const IndustryOrder = require("../models/IndustryOrders");

const router = express.Router();

// 📌 Place Industry Order API
router.post("/place-industry-order", async (req, res) => {
  try {
    const { selectedWaste, address, city, state, zipCode, date, time, location } = req.body;

    if (!selectedWaste || !address || !city || !state || !zipCode || !date || !time || !location) {
      return res.status(400).json({ error: "❌ Missing required fields" });
    }

    console.log("Industry Order Request Body:", req.body);

    const newOrder = new IndustryOrder({
      selectedWaste,
      address,
      city,
      state,
      zipCode,
      date,
      time,
      location
    });

    await newOrder.save();
    res.status(201).json({ message: "✅ Industry order placed successfully!", order: newOrder });
  } catch (error) {
    console.error("❌ Error placing industry order:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

// 📌 Fetch Industry Orders API
router.get("/industry-orders", async (req, res) => {
  try {
    const orders = await IndustryOrder.find().sort({ createdAt: -1 });
    res.status(200).json(orders);
  } catch (error) {
    console.error("❌ Error fetching industry orders:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

module.exports = router;
