// Helper utility to set common CORS headers for Vercel Serverless Functions

function setCorsHeaders(res, allowedMethods = 'GET,POST,DELETE,OPTIONS') {
  res.setHeader('Access-Control-Allow-Credentials', 'true');
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', allowedMethods);
  res.setHeader(
    'Access-Control-Allow-Headers',
    'X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version, Authorization'
  );
}

function handleCors(req, res, allowedMethods = 'GET,POST,DELETE,OPTIONS') {
  setCorsHeaders(res, allowedMethods);
  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return true; // Handled
  }
  return false;
}

module.exports = { setCorsHeaders, handleCors };
