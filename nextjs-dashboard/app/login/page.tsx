'use client';
import AcmeLogo from '@/app/ui/acme-logo';
import LoginForm from '../ui/login-form';

export default function Page() {

    return (
        <main className="flex min-h-screen flex-col items-center">
            <div className="flex h-20 shrink-0 items-end  bg-blue-500  md:h-32 w-full rounded-lg p-4">
                <AcmeLogo />
            </div>
            <div className="w-4/5 justify-self-center mt-32">

                 <LoginForm />
            </div>
        </main>
    );
}
