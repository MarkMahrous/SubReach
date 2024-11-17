import SideNav from '@/app/ui/dashboard/sidenav';
import { AuthProvider } from '@/components/authProvider';

export default function Layout({ children }: { children: React.ReactNode }) {
  return (
    <AuthProvider>

      <div className="flex-grow  md:overflow-y-auto ">{children}</div>

    </AuthProvider>
  );
}