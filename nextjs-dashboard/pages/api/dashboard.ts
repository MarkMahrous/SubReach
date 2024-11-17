import { NextApiRequest, NextApiResponse } from "next";
import { connectToDatabase } from "@/lib/mongoose";
import { User, Video, Campaign } from "@/models/Models";
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
    const compaigns = await Campaign.find();


    const totalUsers = users.length;
    const totalCampaigns = compaigns.length;
    const totalBudgets = compaigns.reduce((acc, campaign) => acc + campaign.budget, 0);
    const totalUserPoints = users.reduce((acc, user) => acc + user.points, 0);

    const videos = await Video.find();

    const revenue = [
        { type: 'Subscription Channel', revenue: compaigns.filter(campaign => campaign.type === 'Subscription Channel').reduce((acc, campaign) => acc + campaign.budget, 0) },
        { type: 'Like Video', revenue: compaigns.filter(campaign => campaign.type === 'Like Video').reduce((acc, campaign) => acc + campaign.budget, 0) },
        { type: 'View Video', revenue: compaigns.filter(campaign => campaign.type === 'View Video').reduce((acc, campaign) => acc + campaign.budget, 0) },
    ]
    const responseUsers = users.map(user => {
        const campaigns = compaigns.filter(campaign => campaign.owner.equals(user._id));
        return {
            ...user.toObject(),
            totalSpent: campaigns.reduce((acc, campaign) => acc + campaign.budget, 0),
            totalCampaigns: campaigns.length,
        }
    });

    return res.status(200).json({ totalUsers, totalCampaigns, totalBudgets, totalUserPoints, responseUsers, revenue });

}
