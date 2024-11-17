import mongoose, { Schema, Document } from 'mongoose';
import bcrypt from 'bcrypt';

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

export const Video = mongoose.models.Video || mongoose.model<IVideo>('Video', VideoSchema);



interface ICampaign extends Document {
  name: string;
  budget: number;
  owner: string;
  type: 'Subscription Channel' | 'Like Video' | 'View Video';
  video: { type: Schema.Types.ObjectId, ref: 'Video' };
}

const CampaignSchema: Schema = new Schema({
  name: { type: String, required: true },
  budget: { type: Number, required: true },
  owner: { type: Schema.Types.ObjectId, ref: 'User' },
  type: { type: String, enum: ['Subscription Channel', 'Like Video', 'View Video'], required: true },
  video: { type: Schema.Types.ObjectId, ref: 'Video' },
});

export const Campaign = mongoose.models.Campaign || mongoose.model<ICampaign>('Campaign', CampaignSchema);

// User Schema
interface IUser extends Document {
  name: string;
  email: string;
  password: string;
  points: number;
  viewedCampaigns: [{ type: Schema.Types.ObjectId, ref: 'Campaign' }];
}

const UserSchema: Schema = new Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  points: { type: Number, default: 0 },
  viewedCampaigns: [{ type: Schema.Types.ObjectId, ref: 'Campaign' }],
});

UserSchema.pre<IUser>('save', function (next) {
  // Check if the password field is modified before saving
  if (!this.isModified('password')) {
    return next();  // If the password is not modified, skip hashing
  }

  // Hash the password before saving
  this.password = bcrypt.hashSync(this.password, 10);

  // Proceed with the save operation
  next();
});

export const User = mongoose.models.User || mongoose.model<IUser>('User', UserSchema);