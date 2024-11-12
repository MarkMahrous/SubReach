import { NextApiRequest, NextApiResponse } from "next";

// This is a placeholder function, replace it with actual logic to fetch points from the database.
const getUserPointsByEmail = async (email: string) => {
  // For now, return 0 (you can replace this with a database query later)
  return 0;
};

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  const { method } = req;
  const { email } = req.query;

  switch (method) {
    case "GET":
      if (!email || Array.isArray(email)) {
        return res
          .status(400)
          .json({ error: "Missing or invalid email parameter" });
      }

      try {
        // Get the points for the user by email
        const points = await getUserPointsByEmail(email);

        // Return the points for the user
        return res.status(200).json({ email, points });
      } catch (error) {
        console.error("Error fetching user points:", error);
        return res.status(500).json({ error: "Failed to fetch user points" });
      }

    default:
      res.setHeader("Allow", ["GET"]);
      return res.status(405).end(`Method ${method} Not Allowed`);
  }
}
