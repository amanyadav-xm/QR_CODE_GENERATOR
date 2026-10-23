# Aman Yadav — Developer Portfolio

A responsive React portfolio with a project manager, skills tracker, learning goals, profile settings, and admin login integration.

## Run locally

Requirements: Node.js 18+ and npm.

```bash
npm install
npm run dev
```

Open the local URL printed by Vite.

## Included features

- Public portfolio with About, Projects, Skills, Learning Journey, and Contact sections.
- Add/edit/archive/delete projects and upload project images.
- Add/edit/delete skills, set progress, and track status.
- Add and update learning goals.
- Profile settings and theme toggle.
- Local browser persistence for quick preview.
- Optional Supabase client integration for authentication (configuration needed).

## Important: demo mode vs production

Without Supabase credentials, edits are saved only in the current browser via `localStorage`. This is useful for previewing the UI, but it is **not secure for a public production admin dashboard** and does not sync across devices. Do not deploy this mode as a secure public admin system.

For production, configure Supabase, create the tables and RLS policies below, and replace the localStorage persistence functions in `src/main.jsx` with authenticated Supabase CRUD/storage operations. The login form already uses Supabase Auth when `.env` credentials are provided, but data CRUD is currently local-only; see the production checklist below.

## Configure Supabase

1. Create a project at https://supabase.com.
2. Copy `.env.example` to `.env` and fill in your project URL and anon/publishable key:

```env
VITE_SUPABASE_URL=https://YOUR_PROJECT.supabase.co
VITE_SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
```

3. In Supabase Authentication, enable Email/Password sign-in and create your own admin user through the dashboard. Do not create a public sign-up route.
4. Run `supabase-schema.sql` in the Supabase SQL editor.
5. Create a private Storage bucket named `portfolio-assets` and add storage policies that allow authenticated admin uploads only. Use a public read bucket only for assets intentionally made public; never upload secrets.
6. Implement and test Supabase database/storage CRUD calls before treating the deployed dashboard as production-ready. RLS must be enabled on every table.

## Deploy

Build the static frontend:

```bash
npm run build
```

Deploy the `dist` directory to Vercel or Netlify. Add the two environment variables in the hosting provider's project settings. Redeploy after changing environment variables.

## Before publishing

- Replace placeholder social links and email in Profile settings.
- Confirm all project claims and skill progress reflect your actual experience.
- Configure Supabase CRUD and RLS; authentication alone does not secure localStorage data.
- Add your own privacy policy/contact handling if collecting messages.
- Test on mobile and desktop.
