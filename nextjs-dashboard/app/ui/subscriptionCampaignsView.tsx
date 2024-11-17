// nextjs-dashboard/app/ui/subscriptionCampaignsView.tsx
'use client';
import * as React from 'react';
import YouTube from 'react-youtube';

const SubscriptionCampaignsView = () => {
  const videoIds = ['M7lc1UVf-VE', 'E7wJTI-1dvQ']; // Replace with actual video IDs

  return (
    <div>
      {videoIds.map((id) => (
        <YouTube key={id} videoId={id} />
      ))}
    </div>
  );
};

export default SubscriptionCampaignsView;