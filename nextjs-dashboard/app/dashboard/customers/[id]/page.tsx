'use client';
import Button from '@mui/material/Button';
import Link from 'next/link';
import { useEffect, useState } from 'react';
import Loading from '../../loading';
import { Customer, FormattedCustomersTable } from '@/app/lib/definitions';

type CustomerPageProps = {
  params: { id: string };
};


export default function Page({ params }: any) {
  const { id } = params;
  console.log(" id ", id);
  // _id: string;
  // name: string;
  // email: string;
  // points: number;
  // totalCampaigns: number;
  // totalSpent: number;
  const [user, setUser] = useState<FormattedCustomersTable>({
    _id: '',
    name: '',
    email: '',
    points: 0,
    totalCampaigns: 0,
    totalSpent: 0,
  });
  const [loading, setLoading] = useState(true);
  const getUser = async () => {
    const response = await fetch(`/api/users/${id}`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      },

    });
    const data = await response.json();
    return data;
  };
  const updateUser = async () => {
    const response = await fetch(`/api/users/${id}`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(user),
    });
    const data = await response.json();
    return data;
  }


  useEffect(() => {
    setLoading(true);
    getUser().then((data) => {
      setUser(data);
      console.log(data);
    })
      .catch((error) => {
        console.error('Error:', error);
      })

      .finally(() => {
        setLoading(false);
      });
  }, []);

  return (
    <form>
      <h1 className={` mb-8 text-xl md:text-2xl`}>
        Edit User
      </h1>

      {loading ? (
        <Loading />
      ) : (
        <>
          <div className="rounded-md bg-gray-50 p-4 md:p-6">
            <div className="mb-4">
              <label htmlFor="amount" className="mb-2 block text-sm font-medium">
                Name
              </label>
              <div className="relative mt-2 rounded-md">
                <div className="relative">
                  <input
                    id="amount"
                    name="amount"
                    value={user.name}
                    onChange={(e) => {
                      setUser({ ...user, name: e.target.value });
                    }}
                    step="0.01"
                    placeholder="Name"
                    className="peer block w-full rounded-md border border-gray-200 py-2 text-sm outline-2 placeholder:text-gray-500"
                  />
                </div>
              </div>
            </div>
            <div className="mb-4">
              <label htmlFor="amount" className="mb-2 block text-sm font-medium">
                Email
              </label>
              <div className="relative mt-2 rounded-md">
                <div className="relative">
                  <input
                    id="amount"
                    name="amount"
                    step="0.01"
                    value={user.email}
                    onChange={(e) => {
                      setUser({ ...user, email: e.target.value });
                    }}
                    placeholder="Email"
                    className="peer block w-full rounded-md border border-gray-200 py-2 text-sm outline-2 placeholder:text-gray-500"
                  />
                </div>
              </div>
            </div>
            <div className="mb-4">
              <label htmlFor="amount" className="mb-2 block text-sm font-medium">
                Points
              </label>
              <div className="relative mt-2 rounded-md">
                <div className="relative">
                  <input
                    id="amount"
                    name="amount"
                    type="number"
                    step="0.01"
                    value={user?.points}
                    onChange={(e) => {
                      setUser({ ...user, points: Number(e.target.value) });
                    }}
                    placeholder="Points"
                    className="peer block w-full rounded-md border border-gray-200 py-2 text-sm outline-2 placeholder:text-gray-500"
                  />
                </div>
              </div>
            </div>


          </div>
          <div className="mt-6 flex justify-end gap-4">
            <Link
              href="/dashboard/customers"
              className="flex h-10 items-center rounded-lg bg-gray-100 px-4 text-sm font-medium text-gray-600 transition-colors hover:bg-gray-200"
            >
              Cancel
            </Link>
            <Button type="submit" variant='contained'
              onClick={(e) => {
                e.preventDefault();
                setLoading(true);
                updateUser().then(() => {
                  console.log("User updated successfully");
                }).catch((error) => {
                  console.error('Error:', error);
                }).finally(() => {

                  getUser().then((data) => {
                    setUser(data);
                  }
                  ).finally(() => {
                    setLoading(false);
                  });

                }
                );
              }
              }
            >Save</Button>
          </div>
        </>
      )}

    </form>

  );
}