const mongoose = require('mongoose');

const ChatSessionSchema = new mongoose.Schema({
  userId: {
    type: String,
    required: true,
    index: true,
  },
  sessionId: {
    type: String,
    required: true,
    unique: true,
  },
  title: {
    type: String,
    required: true,
    default: 'Percakapan Baru',
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
  messages: [
    {
      id: String,
      content: String,
      role: String,
      timestamp: Date,
    },
  ],
});

module.exports = mongoose.models.ChatSession || mongoose.model('ChatSession', ChatSessionSchema);
