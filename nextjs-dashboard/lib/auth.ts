import { compare } from 'bcryptjs';
import { getUserByEmail } from '@/lib/data'; // Adjust the import path if necessary

export async function verifyUserCredentials(email: string, password: string) {
  const user = await getUserByEmail(email);

  if (!user) return null;

  // Use bcrypt to compare the provided password with the stored hashed password
  const isPasswordValid = await compare(password, user.passwordHash);

  return isPasswordValid ? user : null;
}