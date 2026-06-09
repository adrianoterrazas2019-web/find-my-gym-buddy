# Find My Gym Buddy 🏋️

**Find My Gym Buddy** is a social fitness platform that matches you with a compatible workout partner based on your goals, experience, and location. Once paired, you and your buddy can plan sessions together, build shared workout plans, and get personalised coaching from **AIrnold** — an AI fitness coach powered by GPT-4o.

---

## Key Features

- **Smart buddy matching** — full-text search (pg_search + trigram) and a pair-score algorithm that ranks potential partners by compatibility across goals, experience, and fitness profile
- **Friend requests** — send, accept, and deny buddy requests with a pending badge indicator
- **Shared workout plans** — create, edit, and manage exercise plans for each pairing; exercises sourced via semantic (vector) search
- **AIrnold AI coach** — per-pairing and per-workout-plan AI chat that can generate workout plans, edit exercises, and schedule sessions directly to both users' calendars
- **Shared calendar** — view both partners' sessions; AIrnold automatically creates calendar entries after scheduling and links you to the right month
- **Direct messaging** — real-time DMs between buddies using Turbo Streams
- **Profile photo uploads** — powered by Cloudinary
- **6 colour themes + dark/light mode** — theme picker with live preview; preference persisted in `localStorage`
- **Liquid glass UI** — animated fluid background on the home page (Three.js WebGL), glass-morphism navbar and buttons

---

## Tech Stack

| Layer | Technology |
|---|---|
| **Backend** | Ruby on Rails 8.1, PostgreSQL |
| **Frontend** | Hotwire (Turbo + Stimulus), Tailwind CSS v4, Three.js |
| **AI / LLM** | GPT-4o-mini via GitHub Models (Azure OpenAI endpoint), RubyLLM gem |
| **Vector search** | `pgvector` — exercise embeddings via `text-embedding-3-small` |
| **Full-text search** | `pg_search` with trigram support |
| **Auth** | Devise |
| **File uploads** | Cloudinary |
| **Calendar** | simple_calendar gem |
| **Background jobs** | SolidQueue |
| **Asset pipeline** | Propshaft |

---

## Getting Started

### Prerequisites

- Ruby 3.3.5
- PostgreSQL with `pgvector` and `pg_trgm` extensions
- Node.js (for Tailwind CSS build)
- A Cloudinary account
- A GitHub Models API key (or OpenAI API key)

### 1. Clone & install

```bash
git clone https://github.com/adrianoterrazas2019-web/find-my-gym-buddy.git
cd find-my-gym-buddy
bundle install
```

### 2. Environment variables

Create a `.env` file in the project root (or set these in your shell):

```bash
# Database (optional — defaults to local PostgreSQL)
DATABASE_URL=postgresql://localhost/find_my_gym_buddy_development

# AI coach — GitHub Models (free tier)
GITHUB_TOKEN=your_github_personal_access_token

# Or replace with a standard OpenAI key and update config/initializers/ruby_llm.rb
# OPENAI_API_KEY=sk-...

# Cloudinary (profile photo uploads)
CLOUDINARY_URL=cloudinary://api_key:api_secret@cloud_name
```

### 3. Database setup

```bash
bin/rails db:create db:migrate
```

### 4. Seed data + exercise embeddings

> ⚠️ The seed step calls the embedding API — it takes ~30 seconds and requires a valid `GITHUB_TOKEN`.

```bash
bin/rails db:seed
```

### 5. Run the app

```bash
bin/dev
```

This starts:
- `bin/rails server` on `localhost:3000`
- `bin/rails tailwindcss:watch` (live CSS rebuilds)

Open [http://localhost:3000](http://localhost:3000) and log in with any seed user, e.g. `alex@example.com` / `password123`.

---

## Screenshots
attached in the files below showing all major pages

---

## Credits

Built during the [Le Wagon](https://www.lewagon.com) coding bootcamp.
