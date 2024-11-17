"use client";

import { createContext, ReactNode, useContext, useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { usePathname } from 'next/navigation';

interface AuthContextType {
    isAuthenticated: boolean;
    login: () => void;
    logout: () => void;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider = ({ children }: { children: ReactNode }) => {
    const [isAuthenticated, setIsAuthenticated] = useState(false);
    const router = useRouter();
    const pathname = usePathname();

    useEffect(() => {
        const token = localStorage.getItem('authToken');
        console.log('token', token);
        if (token) {
            setIsAuthenticated(true);
        }
    }, []);

    // useEffect(() => {
    //     if (!isAuthenticated && pathname !== '/' && pathname !== '/login') {
    //         router.push('/');
    //     }
    //     if(isAuthenticated && (pathname === '/' || pathname === '/login')) {
    //         router.push('/dashboard');
    //     }
    // }, [isAuthenticated, pathname, router]); // Dependencies for rerun on changes

    const login = () => {
        localStorage.setItem('authToken', 'sample-token');
        setIsAuthenticated(true);
        router.push('/dashboard');
    };

    const logout = () => {
        console.log('logout');
        localStorage.removeItem('authToken');
        setIsAuthenticated(false);
        router.push('/');
    };

    return (
        <AuthContext.Provider value={{ isAuthenticated, login, logout }}>
            {children}
        </AuthContext.Provider>
    );
};

export const useAuth = () => {
    const context = useContext(AuthContext);
    if (!context) {
        throw new Error('useAuth must be used within an AuthProvider');
    }
    return context;
};
