import { NextApiRequest, NextApiResponse } from "next";
import { connectToDatabase } from "@/lib/mongoose";
import {User} from '@/models/Models';
import { auth } from "@/lib/firebaseAdmin";

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  if (req.method !== "POST") {
    return res.status(405).end(); // Method Not Allowed
  }

  const token = req.headers["authorization"];
  if (!token) {
    return res.status(401).json({ error: "Authorization token is required" });
  }

  const { email } = req.body;

  if (!token || !email) {
    return res.status(400).json({ error: "Missing required fields" });
  }

  try {
    // Verify the token with Firebase
    const decodedToken = await auth.verifyIdToken(token);
    const tokenEmail = decodedToken.email;

    if (tokenEmail !== email) {
      return res.status(401).json({ error: "Email does not match token" });
    }

    // Connect to the database
    await connectToDatabase();

    // Find the user by email
    const user = await User.findOne({ email });

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    // Increment the points attribute
    user.points = (user.points || 0) + 1;
    await user.save();

    return res.status(200).json({
      message: "Points incremented successfully",
      points: user.points,
    });
  } catch (error) {
    console.error("Error verifying token or updating points:", error);
    return res
      .status(500)
      .json({ error: "Failed to verify token or update points" });
  }
}
