// nextjs-dashboard/app/ui/campaignsView.tsx
'use client';
import * as React from 'react';
import YouTube from 'react-youtube';

const CampaignsView = () => {
  const videoIds = ['dQw4w9WgXcQ', '3JZ_D3ELwOQ']; // Replace with actual video IDs

  return (
    <div>
      {videoIds.map((id) => (
        <YouTube key={id} videoId={id} />
      ))}
    </div>
  );
};

export default CampaignsView;