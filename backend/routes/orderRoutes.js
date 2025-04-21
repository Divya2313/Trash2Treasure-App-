  const express = require("express");
  const Order = require("../models/UserOrders");

  const router = express.Router();

  // 📌 Place Order API
 // 📌 Place Order API
router.post("/place-order", async (req, res) => {
  try {
    console.log("Request body:", req.body);
    const { selectedWaste, address, city, state, zip, liveLocation } = req.body;

    if (!selectedWaste || !address || !city || !state || !zip || !liveLocation) {
      return res.status(400).json({ error: "❌ Missing required fields" });
    }
    

    const newOrder = new Order({
      selectedWaste,
      address,
      city,
      state,
      zip,
      liveLocation,
    });

    await newOrder.save();
    res.status(201).json({ message: "✅ Order placed successfully!", order: newOrder });
  } catch (error) {
    console.error("❌ Error placing order:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
});
  module.exports = router;
