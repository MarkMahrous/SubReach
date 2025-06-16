#!/bin/bash

# SubReach GitHub Repository Setup Script
# This script helps set up the SubReach repository for public release

echo "🚀 Setting up SubReach Repository..."

# Navigate to SubReach directory
cd /Users/ramezlahzy/Me/ScriptsOfMe/SubReach

# Initialize git if not already initialized
if [ ! -d ".git" ]; then
    echo "📁 Initializing Git repository..."
    git init
fi

# Add all files
echo "📝 Adding files to Git..."
git add .

# Create initial commit
echo "💾 Creating initial commit..."
git commit -m "🎉 Initial release: SubReach - Social Media Growth Platform

Features:
- 📱 Flutter cross-platform mobile app
- 🌐 Next.js TypeScript admin dashboard  
- 💰 Stripe payment integration
- 🎯 Campaign management system
- 📊 Real-time analytics
- 🔐 Firebase authentication & database

Tech Stack: Flutter, Next.js, Firebase, Stripe, TypeScript"

echo "✅ Repository setup complete!"
echo ""
echo "🔧 Next manual steps on GitHub:"
echo "1. Create new repository 'SubReach' on GitHub"
echo "2. Make repository public"
echo "3. Add repository description: 'Social Media Growth Platform - Flutter & Next.js'"
echo "4. Add topics: flutter, dart, nextjs, typescript, firebase, stripe, react, tailwindcss, social-media, engagement-platform, content-creator-tools, mobile-app, web-dashboard, campaign-management, cross-platform, full-stack, payment-integration, real-time, analytics, monetization"
echo "5. Add website: https://github.com/ramezlahzy/SubReach"
echo ""
echo "📤 To push to GitHub (after creating remote repository):"
echo "git remote add origin https://github.com/ramezlahzy/SubReach.git"
echo "git branch -M main" 
echo "git push -u origin main"
