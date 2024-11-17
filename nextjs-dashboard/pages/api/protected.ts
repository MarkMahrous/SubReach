import { NextApiRequest, NextApiResponse } from 'next';
import jwt from 'jsonwebtoken';

const SECRET_KEY = process.env.JWT_SECRET_KEY || 'your_secret_key'; // Use an env variable for your secret

export default function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== 'GET') {
    return res.status(405).json({ message: 'Method not allowed' });
  }

  const token = req.headers.authorization?.split(' ')[1]; // Authorization: Bearer <token>

  if (!token) {
    return res.status(401).json({ message: 'Token is required' });
  }

  try {
    // Verify the JWT token
    const decoded = jwt.verify(token, SECRET_KEY);

    // If the token is valid, you can use the decoded user data
    return res.status(200).json({ message: 'Access granted', user: decoded });
  } catch (error) {
    return res.status(401).json({ message: 'Invalid or expired token' });
  }
}