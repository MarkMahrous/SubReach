'use client';
import CustomersTable from "@/app/ui/customers/table";
import Image from 'next/image';
import { lusitana } from '@/app/ui/fonts';
import Search from '@/app/ui/search';
import {
  CustomersTableType,
  FormattedCustomersTable,
} from '@/app/lib/definitions';
import { useEffect, useState } from 'react';
import { PencilIcon, PlusIcon, TrashIcon } from '@heroicons/react/24/outline';
import Link from 'next/link';
import Loading from "../loading";
import { Button } from "@/app/ui/button";

export default function Page() { // Remove async from component
  const [loading, setLoading] = useState(true);
  const getDashBoardData = async () => {
    const response = await fetch('/api/dashboard', {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      },
    });
    const data = await response.json();
    return data;
  };

  const deleteUser = async (id: string) => {
    const response = await fetch(`/api/users/${id}`, {
      method: 'DELETE',
      headers: {
        'Content-Type': 'application/json',
      },
    });
    const data = await response.json();
    return data;
  }

  const [data, setData] = useState();
  const [users, setUsers] = useState<FormattedCustomersTable[]>([]);
  const [filteredCustomers, setFilteredCustomers] = useState<FormattedCustomersTable[]>([]);
  const [search, setSearch] = useState('');
  useEffect(() => {
    setLoading(true);
    getDashBoardData().then((data) => {
      setData(data);
      console.log(data);
      setUsers(data.responseUsers);
      setFilteredCustomers(data.responseUsers);
    }).finally(() => {
      setLoading(false);
    });
  }, []);

  useEffect(() => {
    if (users) {
      setFilteredCustomers(users.filter((customer) =>
        customer.name.toLowerCase().includes(search.toLowerCase())
      ));
    }
  }, [users, search]);


  return <main>
    <h1 className={`${lusitana.className} mb-8 text-xl md:text-2xl`}>
      Users
    </h1>
    {loading ? (
      <Loading />
    ) : (
      <>

        <div className="mt-6 flow-root">
          <div className="overflow-x-auto">
            <div className="inline-block min-w-full align-middle">
              <div className="overflow-hidden rounded-md bg-gray-100 p-6 md:pt-6">
                <div className="">
                  <div className="mt-6 grid grid-cols-1 gap-1 md:grid-cols-1 lg:grid-cols-1">

                    {filteredCustomers?.map((customer) => (
                      <div
                        key={customer._id}
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
                          <div className="flex justify-end gap-3">
                            <Link
                              href={`/dashboard/customers/${customer._id}`}
                              className="rounded-md border p-2 hover:bg-gray-100"
                            >
                              <PencilIcon className="w-5" />
                            </Link>
                            <Button 
                              className="rounded-md border p-2 hover:bg-gray-100 bg-white"
                              onClick={() => {
                                setLoading(true);
                                deleteUser(customer._id).then(() => {
                                  getDashBoardData().then((data) => {
                                    setData(data);
                                    setUsers(data.responseUsers);
                                    setFilteredCustomers(data.responseUsers);
                                  }
                                  ).finally(() => {
                                    setLoading(false);
                                  });
                                });

                              }}
                            >
                              <TrashIcon className="w-5 text-gray-500" />
                            </Button>


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
                </div>

              </div>
            </div>
          </div>
        </div>
      </>
    )}
  </main>
}