import { connectToDatabase } from "@/lib/mongoose";
import { NextApiRequest, NextApiResponse } from "next";
import { User } from "@/models/Models";

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  const { method } = req;
  const { id } = req.query;

  await connectToDatabase();

  switch (method) {
    case "POST":
      // Existing POST logic for creating a user
      const { name, email, password } = req.body;

      if (!name || !email || !password) {
        return res.status(400).json({ error: "Missing required fields" });
      }

      try {
        const user = new User({ name, email, password });
        await user.save();
        return res.status(201).json(user);
      } catch (error) {
        console.error("Error creating user:", error);
        return res.status(500).json({ error: "Failed to create user" });
      }

    case "DELETE":
      // Existing DELETE logic for removing a user
      if (!id) {
        return res.status(400).json({ error: "Missing required field: id" });
      }

      try {
        const result = await User.deleteOne({ _id: id });
        if (result.deletedCount === 0) {
          return res.status(404).json({ error: "User not found" });
        }
        return res.status(200).json({ message: "User removed successfully" });
      } catch (error) {
        console.error("Error removing user:", error);
        return res.status(500).json({ error: "Failed to remove user" });
      }

    case "PATCH":
      // General PATCH logic for updating user fields
      if (!id) {
        return res.status(400).json({ error: "Missing required field: id" });
      }

      const { points, viewedCampaign } = req.body;

      try {
        const update: any = {};

        // Increment points if provided
        if (points != null) {
          update.$inc = { points }; // Increment points by the provided value
        }

        // Add to viewedCampaigns array if provided
        if (viewedCampaign) {
          update.$addToSet = { viewedCampaigns: viewedCampaign }; // Ensures no duplicates
        }

        // Update the user with dynamic fields
        const user = await User.findByIdAndUpdate(id, update, { new: true });

        if (!user) {
          return res.status(404).json({ error: "User not found" });
        }

        return res.status(200).json(user);
      } catch (error) {
        console.error("Error updating user:", error);
        return res.status(500).json({ error: "Failed to update user" });
      }

    case "GET":
      // Existing GET logic for fetching users
      if (id) {
        try {
          const user = await User.findById(id);
          if (!user) {
            return res.status(404).json({ error: "User not found" });
          }
          return res.status(200).json(user);
        } catch (error) {
          console.error("Error fetching user:", error);
          return res.status(500).json({ error: "Failed to fetch user" });
        }
      } else {
        try {
          const users = await User.find({});
          return res.status(200).json(users);
        } catch (error) {
          console.error("Error fetching users:", error);
          return res.status(500).json({ error: "Failed to fetch users" });
        }
      }

    default:
      res.setHeader("Allow", ["POST", "DELETE", "PATCH", "GET"]);
      return res.status(405).end(`Method ${method} Not Allowed`);
  }
}
