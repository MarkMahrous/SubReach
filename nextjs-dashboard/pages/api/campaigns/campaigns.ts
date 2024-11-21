import { NextApiRequest, NextApiResponse } from "next";
import { connectToDatabase } from "@/lib/mongoose";
import { Campaign, User } from "@/models/Models";

// Handle all campaign-related API requests
export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  const { method } = req;

  await connectToDatabase();

  switch (method) {
    // GET all campaigns
    case "GET":
      try {
        const { type } = req.query;
        const filter = type ? { type } : {};

        const campaigns = await Campaign.find(filter);
        return res.status(200).json(campaigns);
      } catch (error) {
        console.error("Error fetching campaigns:", error);
        return res.status(500).json({ error: "Failed to fetch campaigns" });
      }

    case "POST":
      const { name, budget, owner, type, video } = req.body;

      if (!name || !budget || !owner || !type || !video) {
        return res.status(400).json({ error: "Missing required fields" });
      }

      try {
        // make sure the owner exists
        const user = await User.findById(owner);
        if (!user) {
          return res.status(404).json({ error: "Owner not found" });
        }

        // Create the new campaign
        const campaign = new Campaign({ name, budget, owner, type, video });
        await campaign.save();

        // Update the user's points and createdCampaigns
        user.points -= budget; // or use any other logic to determine points
        user.createdCampaigns.push(campaign._id); // Add the new campaign ID to createdCampaigns
        await user.save(); // Save the updated user

        return res.status(201).json(campaign);
      } catch (error) {
        console.error("Error creating campaign:", error);
        return res.status(500).json({ error: "Failed to create campaign" });
      }

    default:
      res.setHeader("Allow", ["GET", "POST"]);
      return res.status(405).end(`Method ${method} Not Allowed`);
  }
}
