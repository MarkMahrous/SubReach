import { NextApiRequest, NextApiResponse } from 'next';
import { compare } from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { getUserByEmail } from '@/lib/data'; // Adjust the import based on your project

const SECRET_KEY = process.env.JWT_SECRET_KEY || 'your_secret_key'; // Use an env variable for your secret

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== 'POST') 
    return res.status(405).json({ message: 'Method not allowed' });
  
  const { email, password } = req.body;
  if (!email || !password) 
    return res.status(400).json({ message: 'Email and password are required' });

  try {
    const user = await getUserByEmail(email);
    if (!user) 
      return res.status(401).json({ message: 'Invalid credentials' });

    const isPasswordValid = await compare(password, user.password);
    if (!isPasswordValid) 
      return res.status(401).json({ message: 'Invalid credentials' });
    

    // Create a JWT token
    const token = jwt.sign(
      { id: user.id, email: user.email },
      SECRET_KEY,
      { expiresIn: '24h' } // Token expiration
    );

    return res.status(200).json({ token });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Internal server error' });
  }
}