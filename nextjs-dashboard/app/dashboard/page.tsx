export const dynamic = 'force-dynamic';
import { Card } from '@/app/ui/dashboard/cards';
import LatestInvoices from '@/app/ui/dashboard/latest-invoices';
import { lusitana } from '@/app/ui/fonts';
import { Suspense } from 'react';
import { RevenueChartSkeleton } from '@/app/ui/skeletons';
import RevenueChart from '@/app/ui/dashboard/revenue-chart';
import { LatestInvoice, Revenue } from '../lib/definitions';

interface DashboardData {
    totalUsers: number;
    totalCampaigns: number;
    totalBudgets: number;
    totalUserPoints: number;
    responseUsers: LatestInvoice[];
    revenue: Revenue[];
}


export default async function Page() {

    const apiUrl = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3000';

    const getDashBoardData = async (): Promise<DashboardData | null> => {
        try {
            const response = await fetch(`${apiUrl}/api/dashboard`, {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json',
                },
                // Enable caching if desired
                cache: 'no-store', // Prevent caching for fresh data
            });

            if (!response.ok) {
                throw new Error(`Error fetching data: ${response.statusText}`);
            }

            return response.json();
        } catch (error) {
            console.error('Failed to fetch dashboard data:', error);
            return null;
        }
    };

    const dashboardData = await getDashBoardData();

    if (!dashboardData) {
        return <div>Failed to load dashboard data.</div>;
    }


    const { totalUsers, totalCampaigns, totalBudgets, totalUserPoints, responseUsers, revenue } = dashboardData;


    return (
        <main>
            <h1 className={`${lusitana.className} mb-4 text-xl md:text-2xl`}>
                Dashboard
            </h1>
            <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-4">
                <Card title="Total Users" value={totalUsers} type="customers" />
                <Card title="Total Campaigns" value={totalCampaigns} type="invoices" />
                <Card title="Total Budgets" value={totalBudgets} type="collected" />
                <Card title="Total User Points" value={totalUserPoints} type="pending" />
            </div>
            <div className="mt-6 grid grid-cols-1 gap-6 md:grid-cols-4 lg:grid-cols-8">
                <Suspense fallback={<RevenueChartSkeleton />}>
                    <RevenueChart revenue={revenue} />
                </Suspense>
                <LatestInvoices latestInvoices={responseUsers} />
            </div>
        </main>
    );
}


