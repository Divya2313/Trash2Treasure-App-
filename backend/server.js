require("dotenv").config();
const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");

const orderRoutes = require('./routes/orderRoutes');
const app = express();
app.use(express.json());
app.use(cors());
// MongoDB Connection using async-await
const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log("✅ MongoDB Connected");
  } catch (err) {
    console.error("❌ MongoDB Connection Error:", err);
    process.exit(1);
  }
};
connectDB();

// Define User Schema and Model
const userSchema = new mongoose.Schema({
  googleId: { type: String, required: true, unique: true },
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  profilePic: String,
});




const User = mongoose.model("User", userSchema);

// Import Routes

// Google Authentication API
app.post("/api/auth/google", async (req, res) => {
  try {
    const { googleId, name, email, profilePic } = req.body;

    if (!googleId || !name || !email) {
      return res.status(400).json({ error: "Missing required fields" });
    }

    let user = await User.findOne({ googleId });

    if (!user) {
      user = new User({ googleId, name, email, profilePic });
      await user.save();
      return res.status(201).json({ message: "✅ New user created", user });
    }

    res.status(200).json({ message: "✅ User already exists", user });
  } catch (error) {
    console.error("❌ Error in Google Auth API:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
});
// Importing routes
const industryOrderRoutes = require("./routes/IndustryOrderRoutes");

app.use("/api", industryOrderRoutes);

app.use('/api', orderRoutes);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`🚀 Server running on port ${PORT}`));
