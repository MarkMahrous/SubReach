import { NextApiRequest, NextApiResponse } from "next";
import { connectToDatabase } from "@/lib/mongoose";
import { User } from "@/models/Models";
import { auth } from "@/lib/firebaseAdmin";

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  if (req.method !== "GET") {
    return res.status(405).end(); // Method Not Allowed
  }

  // Connect to the database
  await connectToDatabase();
  //return all users
  const users = await User.find();
  return res.status(200).json(users);

}
