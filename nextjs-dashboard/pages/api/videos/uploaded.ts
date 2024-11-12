import { NextApiRequest, NextApiResponse } from "next";

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  const { method } = req;

  switch (method) {
    case "GET":
      // Return an empty array for now
      return res
        .status(200)
        .json([
          "https://www.youtube.com/watch?v=LWskcYMNhes",
          "https://www.youtube.com/watch?v=ioTBIpKCUpM",
          "https://www.youtube.com/watch?v=-g4vvXmE0YI",
          "https://www.youtube.com/watch?v=G28SocqOwOE",
        ]);

    default:
      res.setHeader("Allow", ["GET"]);
      return res.status(405).end(`Method ${method} Not Allowed`);
  }
}
