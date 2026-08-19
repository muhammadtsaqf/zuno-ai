const { handleCors } = require('../utils/cors');
const { handleSessions } = require('../controllers/sessionController');

module.exports = async (req, res) => {
  if (handleCors(req, res, 'GET,POST,DELETE,OPTIONS')) return;
  return handleSessions(req, res);
};

