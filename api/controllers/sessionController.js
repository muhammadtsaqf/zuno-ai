const connectToDatabase = require('../config/db');
const ChatSession = require('../models/ChatSession');

async function handleSessions(req, res) {
  try {
    await connectToDatabase();

    // GET /api/sessions?userId=xyz -> Fetch all sessions for a user
    if (req.method === 'GET') {
      const { userId } = req.query;
      if (!userId) {
        return res.status(400).json({ error: 'userId is required' });
      }
      const sessions = await ChatSession.find({ userId }).sort({ createdAt: -1 });
      return res.status(200).json({ sessions });
    }

    // POST /api/sessions -> Save or Sync a session
    if (req.method === 'POST') {
      const { userId, session } = req.body;
      if (!userId || !session || !session.id) {
        return res.status(400).json({ error: 'userId and valid session object required' });
      }

      const updated = await ChatSession.findOneAndUpdate(
        { sessionId: session.id, userId },
        {
          userId,
          sessionId: session.id,
          title: session.title,
          createdAt: session.createdAt || new Date(),
          messages: session.messages,
        },
        { upsert: true, new: true }
      );

      return res.status(200).json({ message: 'Session saved successfully', session: updated });
    }

    // DELETE /api/sessions?sessionId=xyz & userId=xyz -> Delete specific or ALL sessions
    if (req.method === 'DELETE') {
      const { userId, sessionId, clearAll } = req.query;

      if (!userId) {
        return res.status(400).json({ error: 'userId is required' });
      }

      if (clearAll === 'true') {
        await ChatSession.deleteMany({ userId });
        return res.status(200).json({ message: 'All sessions cleared' });
      }

      if (!sessionId) {
        return res.status(400).json({ error: 'sessionId is required for deletion' });
      }

      await ChatSession.deleteOne({ sessionId, userId });
      return res.status(200).json({ message: 'Session deleted successfully' });
    }

    return res.status(405).json({ error: 'Method not allowed' });
  } catch (error) {
    console.error('Sessions Controller Error:', error);
    return res.status(500).json({ error: 'Server error handling sessions', details: error.message });
  }
}

module.exports = {
  handleSessions,
};
