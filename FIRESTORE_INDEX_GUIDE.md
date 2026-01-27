# Firestore Index Setup Guide

## Problem
The app was unable to fetch organizations because a Firestore composite index was missing for the `members` collection group query.

## Quick Fix Applied ✅
I've modified the `fetchUserOrgs()` method in `org_provider.dart` to:
1. **First fetch organizations where you are the owner** (doesn't require index)
2. **Then attempt to fetch memberships** via collectionGroup (gracefully fails if index doesn't exist)

This means you can now see organizations you created, even without the index!

## Permanent Solution (Recommended)

To enable full functionality (seeing organizations where you're invited as a member), create the Firestore index:

### Option 1: Using Firebase Console (Easiest)
1. Click this link from your error message:
   ```
   https://console.firebase.google.com/v1/r/project/htoochoon-13840/firestore/indexes?create_exemption=...
   ```
2. Click "Create Index"
3. Wait 2-5 minutes for the index to build

### Option 2: Using Firebase CLI
1. Make sure you have Firebase CLI installed:
   ```bash
   npm install -g firebase-tools
   ```

2. Login to Firebase:
   ```bash
   firebase login
   ```

3. Deploy the indexes:
   ```bash
   firebase deploy --only firestore:indexes
   ```

4. Wait for the index to build (you'll see progress in Firebase Console)

## What This Index Does
- Allows efficient querying of all organizations where a user is a member
- Enables the "My Organizations" feature to show both:
  - Organizations you created (owner)
  - Organizations you were invited to (member/teacher/admin)

## Current Behavior
- ✅ Shows organizations you created
- ⚠️ May not show organizations you were invited to (until index is created)

## After Index Creation
- ✅ Shows all organizations (created + invited)
- ✅ Full functionality restored
