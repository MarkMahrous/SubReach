import { NextApiRequest, NextApiResponse } from "next";
import { connectToDatabase, createDemoData } from "@/lib/mongoose";
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
    // await createDemoData();

    const type = req.query.type;

    const users = await User.find();
    const compaigns = await Campaign.find();



    const videos = await Video.find();

    return res.status(200).json(
        compaigns
        .filter(campaign => campaign.type === type)
        .map(campaign => {
            return {
                ...campaign.toObject(),
                owner: users.find(user => user._id.equals(campaign.owner)).toObject(),
                video: videos.find(video => video._id.equals(campaign.video)).toObject(),
                numberOfViews: users.filter(user => user.viewedCampaigns.includes(campaign._id)).length
                
            }
        }
        )
    );


}
