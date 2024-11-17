'use client'
import Image from 'next/image';
import { lusitana } from '@/app/ui/fonts';
import Search from '@/app/ui/search';
import {
  CustomersTableType,
  FormattedCustomersTable,
} from '@/app/lib/definitions';
import { useEffect, useState } from 'react';

export default function CustomersTable({
  customers,
}: {
  customers: FormattedCustomersTable[];
}) {
  const [filteredCustomers, setFilteredCustomers] = useState<FormattedCustomersTable[]>(
    customers
  );

  useEffect(() => {
    setFilteredCustomers(customers);
  }, [customers]);
  return (
    <div className="w-full">
      <h1 className={`${lusitana.className} mb-8 text-xl md:text-2xl`}>
        Customers
      </h1>
      <Search placeholder="Search customers..." onChange={
        (e: any) => {
          const search = e.target.value;
          if (search === '') {
            setFilteredCustomers(customers);
          } else {
            setFilteredCustomers(
              customers.filter((customer) =>
                customer.name.toLowerCase().includes(search.toLowerCase())
              )
            );
          }
        }
      } />
      <div className="mt-6 flow-root">
        <div className="overflow-x-auto">
          <div className="inline-block min-w-full align-middle">
            <div className="overflow-hidden rounded-md bg-gray-100 p-6 md:pt-6">
              <div className="">
                {customers?.map((customer) => (
                  <div
                    key={customer.id}
                    className="mb-6 w-full rounded-md bg-white p-4"
                  >
                    <div className="flex items-center justify-between border-b pb-4">
                      <div>
                        <div className="mb-2 flex items-center">
                          <div className="flex items-center gap-3">

                            <p>{customer.name}</p>
                          </div>
                        </div>
                        <p className="text-sm text-gray-500">
                          {customer.email}
                        </p>
                      </div>
                    </div>


                    <div className="flex w-full items-center justify-between border-b py-5">
                      <div className="flex w-1/2 flex-col">
                        <p className="text-xs">Points</p>
                        <p className="font-medium">{customer.points}</p>
                      </div>
                      <div className="flex w-1/2 flex-col">
                        <p className="text-xs">Total Campaigns</p>
                        <p className="font-medium " >{customer.totalCampaigns} $</p>
                      </div>
                    </div>
                    <div className="pt-4 text-sm flex-col">
                      <p className="text-xs">Total Spent</p>
                      <p className="font-medium">{customer.totalSpent} $</p>
                    </div>
                  </div>
                ))}
              </div>
              <table className="md:hidden min-w-full rounded-md text-gray-900 md:table">
                <thead className="rounded-md bg-gray-50 text-left text-sm font-normal">
                  <tr>
                    <th scope="col" className="px-4 py-5 font-medium sm:pl-6">
                      Name
                    </th>
                    <th scope="col" className="px-3 py-5 font-medium">
                      Email
                    </th>
                    <th scope="col" className="px-3 py-5 font-medium">
                      Total Invoices
                    </th>
                    <th scope="col" className="px-3 py-5 font-medium">
                      Total Pending
                    </th>
                    <th scope="col" className="px-4 py-5 font-medium">
                      Total Paid
                    </th>
                  </tr>
                </thead>

                <tbody className="divide-y divide-gray-200 text-gray-900">
                  {customers.map((customer) => (
                    <tr key={customer.id} className="group">
                      <td className="whitespace-nowrap bg-white py-5 pl-4 pr-3 text-sm text-black group-first-of-type:rounded-md group-last-of-type:rounded-md sm:pl-6">
                        <div className="flex items-center gap-3">
                          {/* <Image
                            src={customer.image_url}
                            className="rounded-full"
                            alt={`${customer.name}'s profile picture`}
                            width={28}
                            height={28}
                          /> */}
                          <p>{customer.name}</p>
                        </div>
                      </td>
                      <td className="whitespace-nowrap bg-white px-4 py-5 text-sm">
                        {customer.email}
                      </td>
                      <td className="whitespace-nowrap bg-white px-4 py-5 text-sm">
                        {/* {customer.total_invoices} */}
                      </td>
                      <td className="whitespace-nowrap bg-white px-4 py-5 text-sm">
                        {/* {customer.total_pending} */}
                      </td>
                      <td className="whitespace-nowrap bg-white px-4 py-5 text-sm group-first-of-type:rounded-md group-last-of-type:rounded-md">
                        {/* {customer.total_paid} */}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
