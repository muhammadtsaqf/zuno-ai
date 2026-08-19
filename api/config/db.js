const mongoose = require('mongoose');

const MONGODB_URI = process.env.MONGODB_URI;

let cachedDb = null;

async function connectToDatabase() {
  if (!MONGODB_URI) {
    throw new Error('MONGODB_URI environment variable is not defined.');
  }

  if (cachedDb && mongoose.connection.readyState === 1) {
    return cachedDb;
  }

  const db = await mongoose.connect(MONGODB_URI, {
    bufferCommands: false,
  });

  cachedDb = db;
  return db;
}

module.exports = connectToDatabase;
