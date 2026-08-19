// Configuration & Environment Constants for Zuno AI Backend Proxy

const JWT_SECRET = process.env.JWT_SECRET;

if (!JWT_SECRET) {
  console.warn('Warning: JWT_SECRET environment variable is missing in Vercel settings!');
}

const AI_CONFIG = {
  host: process.env.AI_HOST || 'https://router.zzam.eu.cc/v1',
  apiKey: process.env.AI_API_KEY,
  defaultModel: process.env.AI_MODEL || 'zuno-pro',
};

const SYSTEM_PROMPT = process.env.SYSTEM_PROMPT || `Kamu adalah Zuno, sebuah AI assistant canggih dan ramah yang diciptakan oleh zzamcode (Muhammad Tsaqif Noor Az Zamil). Kamu sangat serba tahu, cerdas, kreatif, cepat, serta responsif. Kamu selalu menyapa pengguna dengan hangat, membantu menyelesaikan tugas coding, penulisan, ide-ide kreatif, maupun diskusi umum. Selalu sebut dirimu sebagai Zuno dari zzamcode jika ditanya mengenai identitasmu.`;

module.exports = {
  JWT_SECRET: JWT_SECRET || '',
  AI_CONFIG,
  SYSTEM_PROMPT,
};
