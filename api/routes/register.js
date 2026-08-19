const { handleCors } = require('../utils/cors');
const { handleRegister } = require('../controllers/authController');

module.exports = async (req, res) => {
  if (handleCors(req, res, 'POST,OPTIONS')) return;
  return handleRegister(req, res);
};

