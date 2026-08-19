const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const connectToDatabase = require('../config/db');
const User = require('../models/User');
const { JWT_SECRET } = require('../config/constants');

async function handleRegister(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed. Use POST.' });
  }

  try {
    await connectToDatabase();

    const { username, name, email, password } = req.body;

    if (!username || !name || !email || !password) {
      return res.status(400).json({ error: 'Username, Nama, Email, dan Password wajib diisi.' });
    }

    const existingEmail = await User.findOne({ email: email.toLowerCase() });
    if (existingEmail) {
      return res.status(400).json({ error: 'Email sudah terdaftar. Silakan login.' });
    }

    const existingUsername = await User.findOne({ username: username.toLowerCase() });
    if (existingUsername) {
      return res.status(400).json({ error: 'Username sudah digunakan. Pilih username lain.' });
    }

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    const user = new User({
      username: username.toLowerCase(),
      name,
      email: email.toLowerCase(),
      password: hashedPassword,
    });

    await user.save();

    const token = jwt.sign(
      { userId: user._id, username: user.username, email: user.email, name: user.name },
      JWT_SECRET,
      { expiresIn: '30d' }
    );

    return res.status(201).json({
      message: 'Registrasi berhasil!',
      token,
      user: {
        id: user._id,
        username: user.username,
        name: user.name,
        email: user.email,
      },
    });
  } catch (error) {
    console.error('Register Error:', error);
    return res.status(500).json({ error: 'Terjadi kesalahan pada server saat registrasi.', details: error.message });
  }
}

async function handleLogin(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed. Use POST.' });
  }

  try {
    await connectToDatabase();

    const { identifier, email, username, password } = req.body;
    const loginId = identifier || email || username;

    if (!loginId || !password) {
      return res.status(400).json({ error: 'Username/Email dan Password wajib diisi.' });
    }

    const query = loginId.includes && loginId.includes('@')
      ? { email: loginId.toLowerCase() }
      : {
          $or: [
            { email: loginId.toLowerCase() },
            { username: loginId.toLowerCase() }
          ]
        };

    const user = await User.findOne(query);
    if (!user) {
      return res.status(400).json({ error: 'Username/Email atau password salah.' });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ error: 'Username/Email atau password salah.' });
    }

    const token = jwt.sign(
      { userId: user._id, username: user.username, email: user.email, name: user.name },
      JWT_SECRET,
      { expiresIn: '30d' }
    );

    return res.status(200).json({
      message: 'Login berhasil!',
      token,
      user: {
        id: user._id,
        username: user.username,
        name: user.name,
        email: user.email,
      },
    });
  } catch (error) {
    console.error('Login Error:', error);
    return res.status(500).json({ error: 'Terjadi kesalahan pada server saat login.', details: error.message });
  }
}

module.exports = {
  handleRegister,
  handleLogin,
};
