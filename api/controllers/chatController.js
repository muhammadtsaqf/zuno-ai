const axios = require('axios');
const { AI_CONFIG, SYSTEM_PROMPT } = require('../config/constants');

async function handleChatCompletions(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed. Use POST.' });
  }

  try {
    const { messages, model, stream } = req.body;

    if (!messages || !Array.isArray(messages)) {
      return res.status(400).json({ error: 'Payload requires a "messages" array.' });
    }

    const targetModel = model || AI_CONFIG.defaultModel;

    // Build formatted messages
    let formattedMessages = [...messages];

    // Only inject System Prompt if the model is 'zuno-pro' (or if no specific raw model is targeted)
    if (targetModel === 'zuno-pro') {
      if (!formattedMessages.some((m) => m.role === 'system')) {
        formattedMessages.unshift({
          role: 'system',
          content: SYSTEM_PROMPT,
        });
      }
    }

    // Determine actual backend AI router model ID
    // Zuno Pro combines and uses qd/qmodel_38max as its high-speed baseline model with Zuno Persona
    let actualModel = targetModel;
    if (targetModel === 'zuno-pro') {
      actualModel = process.env.ZUNO_PRO_BASE_MODEL || 'qd/qmodel_38max';
    }

    const payload = {
      model: actualModel,
      messages: formattedMessages,
      temperature: 0.7,
      stream: stream || false,
    };

    const response = await axios.post(`${AI_CONFIG.host}/chat/completions`, payload, {
      headers: {
        Authorization: `Bearer ${AI_CONFIG.apiKey}`,
        'Content-Type': 'application/json',
      },
      responseType: stream ? 'stream' : 'json',
      timeout: 60000,
    });

    if (stream) {
      res.setHeader('Content-Type', 'text/event-stream');
      res.setHeader('Cache-Control', 'no-cache');
      res.setHeader('Connection', 'keep-alive');
      response.data.pipe(res);
    } else {
      res.status(200).json(response.data);
    }
  } catch (error) {
    console.error('Chat Controller Error:', error.response?.data || error.message);
    res.status(error.response?.status || 500).json({
      error: 'Failed to communicate with Zuno AI Core API',
      details: error.response?.data || error.message,
    });
  }
}

module.exports = {
  handleChatCompletions,
};
