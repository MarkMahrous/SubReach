import { NextApiRequest, NextApiResponse } from "next";

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  const { method } = req;

  switch (method) {
    case "POST":
      const { email, url, minus_points } = req.body;

      if (!email || !url) {
        return res
          .status(400)
          .json({ error: "Missing required fields: email and url" });
      }

      return res
        .status(200)
        .json({
          message: "Email and URL received successfully and Points are minused",
        });

    default:
      res.setHeader("Allow", ["POST"]);
      return res.status(405).end(`Method ${method} Not Allowed`);
  }
}
