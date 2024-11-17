'use client';
import CustomersTable from "@/app/ui/customers/table";
import { useEffect, useState } from "react";

export default function Page() { // Remove async from component
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

  const [data, setData] = useState();
  const [users, setUsers] = useState([]);
  useEffect(() => {
    getDashBoardData().then((data) => {
      setData(data);
      console.log(data);
      setUsers(data.responseUsers);
    });
  }, []); // Ensure dependency array is empty to only run once
  // return <></>
  return <CustomersTable customers={users} />;
}