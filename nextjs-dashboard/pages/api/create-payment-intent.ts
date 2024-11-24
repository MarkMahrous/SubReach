import { NextApiRequest, NextApiResponse } from 'next';
import Stripe from 'stripe';

const stripe = new Stripe('sk_test_51PIwOLRxDoUeGEPbjvvzUk0UeucArzMWMXaeR1gzb6uzhKUDXNjArythAZr7cpUGvApVG6IsFsd1Fz5a4ofB2xmI00n59KW9Ty', {
    apiVersion: '2024-11-20.acacia',
});

export default async function handler(
    req: NextApiRequest,
    res: NextApiResponse
) {
    console.log('req.method', req.method);
    if (req.method !== 'POST') {
        res.setHeader('Allow', 'POST');
        res.status(405).end('Method Not Allowed');
        return;
    }

    const { amount } = req.body;

    if (!amount) {
        res.status(400).json({ error: 'Amount is required' });
        return;
    }

    try {
        const paymentIntent = await stripe.paymentIntents.create({
            amount: Math.round(amount), // Amount in cents
            currency: 'usd',
            payment_method_types: ['card'],
        });
        const account = await stripe.accounts.retrieve();
        console.log("account ", account);
        // console.log('paymentIntent', paymentIntent);

        res.status(200).json(paymentIntent);
    } catch (error) {
        res
            .status(500)
            .json({ error: error instanceof Error ? error.message : 'Unknown error' });
    }
}
