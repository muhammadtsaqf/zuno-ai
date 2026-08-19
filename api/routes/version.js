const handleCors = require('../utils/cors');

module.exports = async (req, res) => {
  if (handleCors(req, res)) return;

  // Returning current minimum required app version and download URL
  return res.status(200).json({
    latestVersion: process.env.LATEST_APP_VERSION || '1.0.0',
    minRequiredVersion: process.env.MIN_REQUIRED_VERSION || '1.0.0',
    updateUrl: process.env.APP_UPDATE_URL || 'https://github.com/muhammadtsaqf/zuno-ai/releases',
    changelog: process.env.UPDATE_CHANGELOG || 'Pembaruan keamanan dan peningkatan performa.',
    forceUpdate: process.env.FORCE_UPDATE === 'true',
  });
};
