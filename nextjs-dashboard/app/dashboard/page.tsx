'use client';

import { Card } from '@/app/ui/dashboard/cards';
import LatestInvoices from '@/app/ui/dashboard/latest-invoices';
import { lusitana } from '@/app/ui/fonts';
import { useEffect, useState } from 'react';
import { RevenueChartSkeleton } from '@/app/ui/skeletons';
import RevenueChart from '@/app/ui/dashboard/revenue-chart';
import { LatestInvoice, Revenue } from '../lib/definitions';
import { Skeleton } from '@mui/material';
import Loading from './loading';

export const dynamic = 'force-dynamic';

interface DashboardData {
    totalUsers: number;
    totalCampaigns: number;
    totalBudgets: number;
    totalUserPoints: number;
    responseUsers: LatestInvoice[];
    revenue: Revenue[];
}

export default function Page() {
    const [dashboardData, setDashboardData] = useState<DashboardData>({
        totalUsers: 0,
        totalCampaigns: 0,
        totalBudgets: 0,
        totalUserPoints: 0,
        responseUsers: [],
        revenue: [],
    });
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);

    const getDashBoardData = async () => {
        try {
            const response = await fetch(`/api/dashboard`, {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json',
                },
                cache: 'no-store', // Prevent caching for fresh data
            });

            if (!response.ok) {
                throw new Error(`Error fetching data: ${response.statusText}`);
            }

            const data: DashboardData = await response.json();
            return data
        } catch (err) {
            console.error('Failed to fetch dashboard data:', err);
        } finally {
        }
    };

    useEffect(() => {
        getDashBoardData().then((data: any) => {
            setDashboardData(data);
            setLoading(false);
        }
        );

    }, [null]);

    return (
        <main>
            <h1 className={`${lusitana.className} mb-4 text-xl md:text-2xl`}>
                Dashboard
            </h1>

            {/* Loading or Error State */}
            {loading ? (
                <Loading />
            ) : error ? (
                <div className="text-center mt-6 text-red-500">{error}</div>
            ) : (
                <>
                    {/* Dashboard Cards */}
                    <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-4">
                        <Card title="Total Users" value={dashboardData?.totalUsers} type="customers" />
                        <Card title="Total Campaigns" value={dashboardData?.totalCampaigns} type="invoices" />
                        <Card title="Total Budgets" value={dashboardData?.totalBudgets} type="collected" />
                        <Card title="Total User Points" value={dashboardData?.totalUserPoints} type="pending" />
                    </div>

                    {/* Revenue Chart and Latest Invoices */}
                    <div className="mt-6 grid grid-cols-1 gap-6 md:grid-cols-4 lg:grid-cols-8">
                        {dashboardData?.revenue.length ? (
                            <RevenueChart revenue={dashboardData?.revenue} />
                        ) : (
                            <RevenueChartSkeleton />
                        )}
                        <LatestInvoices latestInvoices={dashboardData?.responseUsers} />
                    </div>
                </>
            )}
        </main>
    );
}
