// nextjs-dashboard/app/ui/likeCampaignsView.tsx
'use client';
import * as React from 'react';
import YouTube from 'react-youtube';

const LikeCampaignsView = () => {
  const videoIds = ['kJQP7kiw5Fk', 'RgKAFK5djSk']; // Replace with actual video IDs

  return (
    <div>
      {videoIds.map((id) => (
        <YouTube key={id} videoId={id} />
      ))}
    </div>
  );
};

export default LikeCampaignsView;