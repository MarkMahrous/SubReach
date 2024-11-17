'use client';
import * as React from 'react';
import Stack from '@mui/material/Stack';
import Button from '@mui/material/Button';
import CampaignsView from '@/app/ui/campaignsView';
import SubscriptionCampaignsView from '@/app/ui/subscriptionCampaignsView';
import LikeCampaignsView from '@/app/ui/likeCampaignsView';
import InvoicesTable from '@/app/ui/invoices/table';
import Loading from '../loading';
import { InvoicesTableSkeleton } from '@/app/ui/skeletons';
import Link from 'next/link';

export default function Page() {
  // Subscription Channel', 'Like Video', 'View Video'
  const [selectedView, setSelectedView] = React.useState('Subscription Channel');
  const [loading, setLoading] = React.useState(true);
  const getCampaignsData = async () => {
    const response = await fetch(`/api/campaigns?type=${selectedView}`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      },

    });
    const data = await response.json();
    return data;
  };
  interface Campaign {
    _id: string;
    owner: { email: string };
    budget: number;
    numberOfViews: number;
    video?: { url: string; title: string };
  }

  const [campaigns, setCampaigns] = React.useState<Campaign[]>([]);
  React.useEffect(() => {
    setLoading(true);
    getCampaignsData().then((data) => {
      console.log(data);
      setCampaigns(data);
      setLoading(false);
    });
  }, [selectedView]);
  // if (loading) {
  //   return <Loading />
  // }
  return (
    <div>
      <Stack direction="row" spacing={2} justifyContent="center" marginTop={4}>
        <Button
          variant={selectedView === 'View Video' ? 'contained' : 'outlined'}
          onClick={() => setSelectedView('View Video')}
        >
          View Campaigns
        </Button>
        <Button
          variant={selectedView === 'Subscription Channel' ? 'contained' : 'outlined'}
          onClick={() => setSelectedView('Subscription Channel')}
        >
          Subscription Campaigns
        </Button>
        <Button
          variant={selectedView === 'Like Video' ? 'contained' : 'outlined'}
          onClick={() => setSelectedView('Like Video')}
        >
          Like Campaigns
        </Button>
      </Stack>
      {
        loading ? <InvoicesTableSkeleton /> : (

          <div className="mt-6 flow-root">
            <div className="inline-block min-w-full align-middle">
              <div className="rounded-lg bg-gray-50 p-2 md:pt-0">

                <table className="hidden min-w-full text-gray-900 md:table">
                  <thead className="rounded-lg text-left text-sm font-normal">
                    <tr>
                      <th scope="col" className="px-4 py-5 font-medium sm:pl-6">
                        Owner
                      </th>
                      <th scope="col" className="px-3 py-5 font-medium">
                        Budget
                      </th>
                      <th scope="col" className="px-3 py-5 font-medium">
                        Number of {selectedView === 'Subscription Channel' ? 'Subscribers' : selectedView === 'Like Video' ? 'Likes' : 'Views'}
                      </th>
                      <th scope="col" className="px-3 py-5 font-medium">
                        Video
                      </th>
                    </tr>
                  </thead>
                  <tbody className="bg-white">
                    {campaigns?.map((campaign) => (
                      <tr
                        key={campaign._id}
                        className="w-full border-b py-3 text-sm last-of-type:border-none [&:first-child>td:first-child]:rounded-tl-lg [&:first-child>td:last-child]:rounded-tr-lg [&:last-child>td:first-child]:rounded-bl-lg [&:last-child>td:last-child]:rounded-br-lg"
                      >
                        <td className="whitespace-nowrap px-3 py-3">
                          {campaign.owner.email}
                        </td>
                        <td className="whitespace-nowrap px-3 py-3">
                          {campaign.budget}
                        </td>
                        <td className="whitespace-nowrap px-3 py-3">
                          {campaign.numberOfViews}
                        </td>
                        <td className="whitespace-nowrap px-3 py-3">
                          {campaign.video && campaign.video.url ? (
                            <a
                              href={`https://www.youtube.com/watch?v=${campaign.video.url}`}
                              target="_blank"
                              rel="noopener noreferrer"
                              className="text-blue-500 underline"
                            >
                              {campaign.video.title}
                            </a>
                          ) : (
                            <span>No video available</span>
                          )}
                        </td>

                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        )}
    </div>
  );
}