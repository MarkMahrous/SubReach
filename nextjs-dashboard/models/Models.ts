import mongoose, { Schema, Document } from "mongoose";
import bcrypt from "bcrypt";

// Video Schema
interface IVideo extends Document {
  title: string;
  url: string;
  description: string;
}

const VideoSchema: Schema = new Schema({
  title: { type: String, required: true },
  url: { type: String, required: true },
  description: { type: String },
});

export const Video =
  mongoose.models.Video || mongoose.model<IVideo>("Video", VideoSchema);

interface ICampaign extends Document {
  name: string;
  budget: number;
  time: number;
  owner: string;
  type: "Subscribe" | "Like" | "View";
  video: string; // Video ID
}

const CampaignSchema: Schema = new Schema({
  name: { type: String, required: true },
  budget: { type: Number, required: true },
  time: { type: Number, default: 0 },
  owner: { type: Schema.Types.ObjectId, ref: "User" },
  type: {
    type: String,
    enum: ["Subscribe", "Like", "View"],
    required: true,
  },
  video: { type: String, required: true }, // Video ID
});

export const Campaign =
  mongoose.models.Campaign ||
  mongoose.model<ICampaign>("Campaign", CampaignSchema);

// User Schema
interface IUser extends Document {
  name: string;
  email: string;
  password: string;
  points: number;
  viewedCampaigns: [{ type: Schema.Types.ObjectId; ref: "Campaign" }];
  createdCampaigns: [{ type: Schema.Types.ObjectId; ref: "Campaign" }];
}

const UserSchema: Schema = new Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  points: { type: Number, default: 5000 },
  viewedCampaigns: [{ type: Schema.Types.ObjectId, ref: "Campaign" }],
  createdCampaigns: [{ type: Schema.Types.ObjectId, ref: "Campaign" }],
});

UserSchema.pre<IUser>("save", async function (next) {
  if (!this.isModified("password")) {
    return next();
  }

  try {
    this.password = await bcrypt.hash(this.password, 10);
    next();
  } catch (error) {
    next();
  }
});

export const User =
  mongoose.models.User || mongoose.model<IUser>("User", UserSchema);
