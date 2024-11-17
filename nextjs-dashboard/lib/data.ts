import { connectToDatabase, createDemoData } from './mongoose';
import { User } from '@/models/Models';


export const getUserByEmail = async (email: string) => {

  await connectToDatabase();
  const user = await User.findOne({ email });
  return user;
}

