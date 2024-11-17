
import { NextApiRequest, NextApiResponse } from 'next';
import {User} from '@/models/Models';
import { connectToDatabase } from './mongoose';

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
    if (req.method !== 'POST') {
        return res.status(405).end(); // Method Not Allowed
    }

    const { name, email, password } = req.body;

    if (!name || !email || !password) {
        return res.status(400).json({ error: 'Missing required fields' });
    }

    try {
        await connectToDatabase();
        const user = new User({ name, email, password });
        await user.save();
        return res.status(201).json(user);
    } catch (error) {
        console.error('Error creating user:', error);
        return res.status(500).json({ error: 'Failed to create user' });
    }
}