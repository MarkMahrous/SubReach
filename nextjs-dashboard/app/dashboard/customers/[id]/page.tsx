'use client';
import * as React from 'react';
import Stack from '@mui/material/Stack';
import Button from '@mui/material/Button';
import CampaignsView from '@/app/ui/campaignsView';
import SubscriptionCampaignsView from '@/app/ui/subscriptionCampaignsView';
import LikeCampaignsView from '@/app/ui/likeCampaignsView';
import InvoicesTable from '@/app/ui/invoices/table';
import Loading from '../../loading';
import { InvoicesTableSkeleton } from '@/app/ui/skeletons';
import Link from 'next/link';
import EditInvoiceForm from '@/app/ui/invoices/edit-form';

import {
  CheckIcon,
  ClockIcon,
  CurrencyDollarIcon,
  UserCircleIcon,
} from '@heroicons/react/24/outline';

type CustomerPageProps = {
  params: { id: string };
};


export default function Page({ params }: any) {
  const { id } = params;
  console.log(" id ", id);
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
    <form>
      <div className="rounded-md bg-gray-50 p-4 md:p-6">
        <div className="mb-4">
          <label htmlFor="amount" className="mb-2 block text-sm font-medium">
            Choose an amount
          </label>
          <div className="relative mt-2 rounded-md">
            <div className="relative">
              <input
                id="amount"
                name="amount"
                type="number"
                step="0.01"
                // defaultValue={invoice.amount}
                placeholder="Enter USD amount"
                className="peer block w-full rounded-md border border-gray-200 py-2 pl-10 text-sm outline-2 placeholder:text-gray-500"
              />
              <CurrencyDollarIcon className="pointer-events-none absolute left-3 top-1/2 h-[18px] w-[18px] -translate-y-1/2 text-gray-500 peer-focus:text-gray-900" />
            </div>
          </div>
        </div>

        {/* Invoice Status */}
        <fieldset>
          <legend className="mb-2 block text-sm font-medium">
            Set the invoice status
          </legend>
          <div className="rounded-md border border-gray-200 bg-white px-[14px] py-3">
            <div className="flex gap-4">
              <div className="flex items-center">
                <input
                  id="pending"
                  name="status"
                  type="radio"
                  value="pending"
                  // defaultChecked={invoice.status === 'pending'}
                  className="h-4 w-4 cursor-pointer border-gray-300 bg-gray-100 text-gray-600 focus:ring-2"
                />
                <label
                  htmlFor="pending"
                  className="ml-2 flex cursor-pointer items-center gap-1.5 rounded-full bg-gray-100 px-3 py-1.5 text-xs font-medium text-gray-600"
                >
                  Pending <ClockIcon className="h-4 w-4" />
                </label>
              </div>
              <div className="flex items-center">
                <input
                  id="paid"
                  name="status"
                  type="radio"
                  value="paid"
                  // defaultChecked={invoice.status === 'paid'}
                  className="h-4 w-4 cursor-pointer border-gray-300 bg-gray-100 text-gray-600 focus:ring-2"
                />
                <label
                  htmlFor="paid"
                  className="ml-2 flex cursor-pointer items-center gap-1.5 rounded-full bg-green-500 px-3 py-1.5 text-xs font-medium text-white"
                >
                  Paid <CheckIcon className="h-4 w-4" />
                </label>
              </div>
            </div>
          </div>
        </fieldset>
      </div>
      <div className="mt-6 flex justify-end gap-4">
        <Link
          href="/dashboard/customers"
          className="flex h-10 items-center rounded-lg bg-gray-100 px-4 text-sm font-medium text-gray-600 transition-colors hover:bg-gray-200"
        >
          Cancel
        </Link>
        <Button type="submit">Edit Invoice</Button>
      </div>
    </form>

  );
}