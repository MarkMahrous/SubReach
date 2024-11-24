import { Campaign, User, Video } from "@/models/Models";
import mongoose from "mongoose";
import { faker } from "@faker-js/faker";
import { randomInt } from "crypto";
const MONGODB_URI = "mongodb://admin:newpassword@139.84.235.142:27017/admin";

if (!MONGODB_URI) {
  throw new Error(
    "Please define the MONGODB_URI environment variable inside .env.local"
  );
}

async function dropAllCollections() {
  const connection = await mongoose.connect(MONGODB_URI);
  const collections =
    (await mongoose.connection.db?.listCollections().toArray()) || [];
  console.log("Dropping all collections...");
  console.log(collections);
  for (const collection of collections) {
    if (collection.name.startsWith("system.")) {
      console.log(`Skipping system collection: ${collection.name}`);
      continue;
    }

    await mongoose.connection.db?.dropCollection(collection.name);
    console.log(`Dropped collection: ${collection.name}`);
  }

  await connection.disconnect();
}
/**
 * Global is used here to maintain a cached connection across hot reloads in development.
 * This prevents connections growing exponentially during API Route usage.
 */
let cached = global.mongoose;

if (!cached) {
  cached = global.mongoose = { conn: null, promise: null };
}

async function connectToDatabase() {
  if (cached.conn) {
    return cached.conn;
  }
  if (!cached.promise) {
    cached.promise = mongoose
      .connect(MONGODB_URI, {
        serverSelectionTimeoutMS: 5000, // Optional: Timeout to avoid indefinite waiting
        family: 4, // Optional: Forces the use of IPv4 addresses
      })
      .then((mongoose) => {
        return mongoose;
      });
  }
  cached.conn = await cached.promise;
  return cached.conn;
}

// Create demo video data
const createDemoVideos = async () => {
  //delete all tables
  //list collections
  //   const videos = [];
  //   for (let i = 0; i < 10; i++) {
  //     const video = new Video({
  //       title: faker.commerce.productName(),
  //       url: videosId[i],
  //       description: faker.lorem.sentence(),
  //     });
  //     videos.push(video);
  //     await video.save();
  //   }
  //   console.log("10 demo videos created!");
  //   return videos;
};

// Create demo campaign data
const createDemoCampaigns = async (videos: any[], users: any[]) => {
  const campaigns = [];

  for (let i = 0; i < 10; i++) {
    const video = videos[i % videos.length]; // Cycle through the 10 videos
    const user = users[i % users.length]; // Cycle through the 10 users
    const campaign = new Campaign({
      name: faker.company.catchPhrase(),
      budget: randomInt(0, 1000),
      owner: user._id,
      type: ["Subscription Channel", "Like Video", "View Video"][i % 3], // Alternate campaign types
      video: video._id,
    });
    campaigns.push(campaign);
    await campaign.save();
  }

  console.log("10 demo campaigns created!");
  return campaigns;
};

// Create demo user data
const createDemoUsers = async () => {
  const users = [];
  for (let i = 0; i < 10; i++) {
    const user = new User({
      name: faker.person.firstName(),
      email: faker.internet.email(),
      password: faker.internet.password(),
      points: randomInt(0, 1000),
      viewedCampaigns: [],
    });

    await user.save();
    users.push(user);
  }
  return users;

  console.log("10 demo users created!");
};

// Execute the functions to create demo data
const createDemoData = async () => {

   



    const videos = await createDemoVideos();
    const users = await createDemoUsers();
    // const campaigns = await createDemoCampaigns(videos, users);

 
    const admin = new User({
        name: 'Admin',
        email: 'admin@gmail.com',
        password: 'Admin123@',
        points: 0,
        viewedCampaigns: [],
    });
    await admin.save();
    console.log('Admin user created!');
    //get all users
    // const users = await User.find();
    // console.log('All users:', users);
    //get all videos
    console.log('Demo data created successfully!');
    mongoose.connection.close(); // Close the connection after data is inserted
};

// Start the demo data creation
export { connectToDatabase, createDemoData };
