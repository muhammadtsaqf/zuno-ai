const { handleCors } = require('../utils/cors');
const { handleLogin } = require('../controllers/authController');

module.exports = async (req, res) => {
  if (handleCors(req, res, 'POST,OPTIONS')) return;
  return handleLogin(req, res);
};

