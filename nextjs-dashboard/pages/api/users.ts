import { NextApiRequest, NextApiResponse } from "next";
import { connectToDatabase, createDemoData } from "@/lib/mongoose";
import { User } from "@/models/Models";
import { auth } from "@/lib/firebaseAdmin";

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  // if (req.method !== "GET") {
  //   return res.status(405).end(); // Method Not Allowed
  // }
  if (req.method === "POST") {
    const body = req.body;
    const { email, password } = body;
    if (!email || !password) {
      return res.status(400).json({ error: "Email and password are required" });
    }
    // Connect to the database
    await connectToDatabase();
    //create new user
    const newUser = new User({ email, password });
    await newUser.save();
    return res.status(201).json(newUser);
  }

  // Connect to the database
  // await connectToDatabase();
  await createDemoData();
  //return all users
  // const users = await User.find();
  // return res.status(200).json(users);
}
