const { handleCors } = require('../utils/cors');
const { handleChatCompletions } = require('../controllers/chatController');

module.exports = async (req, res) => {
  if (handleCors(req, res, 'GET,OPTIONS,PATCH,DELETE,POST,PUT')) return;
  return handleChatCompletions(req, res);
};

