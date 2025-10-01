# Banksy Project Development AI Usage Report

## Overview
This document is an overview of how AI was used to tackle the goal of building an MVP banking application.
I want to be clear that normally I would use one language for the frontend and backend to make things as simple as possible.
I could have completed this faster with just NextJS or Javascript and NodeJS in the backend.
However, I wanted to challenge myself and demonstrate proficiency in both languages since Python is used heavily in the AI landscape.

This isn't the first time I created an application using AI tooling but this has been the most successful attempt.
I started developing with Gemini 2.5 flash and the new thinking model, I have used this in the past to develop frontend apps quickly
but this time it failed me when attempting to create API routes in python. I prefer not to use Cursor or any other AI IDE as I have had a poor experience with them recently.
The issue with the IDE's is that they are relatively new, often times the project structure goes awry quickly and as a human, I lose context of what is being built. 
The strategy of copying code from the chat window allows me to proofread the code and review before I accept it. I will give IDE's another try in the future

At this point I opted to use ChatGPT 5.0 with Webstorm IDE integrated chat tools even though my experience with ChatGPT's early models proved extremely challenging and was more of a headache than a solution.
I persisted anyway and the results were very surprising. I was able to quickly scaffold a project using FastAPI and NextJS. There were challenges, especially in the following areas,

* Managing 2 different project languages for the backend and frontend posed unique challenges, AI was able to help me get through a lot of the issues I encountered though. 
* Docker files were not working initially, I went back and forth with ChatGPT and eventually had to tweak how the files were being copied from my machine to the docker image.
* In addition to this, I had to create 2 pnpm-lock.yaml files in the root directory and the frontend directory although this isn't recommended. 
* In the future I would not use a root project to launch both the server and frontend at the same time as ChatGPT suggested. I found this was more of a headache than a solution.
* Frontend tests were often failing when using AI. I tried several things and eventually determined I would be more efficient writing these on my own later.
* Backend tests were really good but the AI struggled to mock data correctly and set up conftest.py. I eventually had to tweak a lot of the tests to get them to work.
* The AI would consistently recommend incorrect imports, I was able to correct it eventually and those errors were resolved. This is the first time it listened to my suggestions.
* Often times the AI would lag or crash on me, this was ok though, the entire conversation would be recovered on restart.
* The AI's memory has significantly improved from the last time I created and application with AI.
* AI had problems with Async driver errors with SQLAlchemy ® Configured correct async drivers and ORM bindings.
* AI was extremely helpful in identifying discrepancies with Windows to Linux builds for Docker, especially in the case of normalized LF endings
* AI struggled to assist me with standard styles throughout the application. It ignored global.css settings and I went in and manually updated this. I could have prompted this better.

All in all, this was an amazing experience given the speed at which I was able to accomplish tasks with AI. ChatGPT 5.0 was the perfect peer programmer. 
It enabled me to think outside the box, and provided unique insight into different ways to tackling the same problem.
I will continue to use these tools as they improve over time. 

For a summary of what I achieved view the `banksy_hybrid_export.md` and for the case study view `case_study_banksy.pdf`
For my full conversation see `banksy_conversation_full_raw.md`

---

# Part 1: Professional Summary

## Backend Development
- **Frameworks**: FastAPI, SQLAlchemy (async), Alembic for migrations, SQLite (dev), PostgreSQL (prod).
- **Features Implemented**:
    - Authentication integration with Clerk.
    - Core models: `User`, `Account`, `Transaction`.
    - Extensions: `AccountHolder`, `Card`, `MoneyTransfer`, `ErrorLogger`.
    - Middleware for error logging with DB persistence.
    - Statement generation from transaction history (dynamic, no extra model).
- **Key Decisions**:
    - `AccountHolder` as join-table for flexible account ownership types.
    - `MoneyTransfer` creates **two Transactions** (debit & credit).
    - Positive-only `Transaction.amount` with logic to adjust for DEBIT vs CREDIT.

## Testing
- **Framework**: Pytest + pytest-asyncio.
- **Fixtures**:
    - In-memory SQLite database for isolation.
    - `authorized_client` mocking Clerk JWTs.
    - Auto-cleanup between tests.
- **Coverage**: ~65% at MVP (goal 80%+).
- **Highlights**:
    - End-to-end error logging tests (raise exception → DB log entry).
    - Transaction ownership checks.
    - Account creation auto-assigns `PRIMARY` holder.
    - Statement generation verified with credit/debit adjustments.

## Frontend Development
- **Framework**: Next.js 15 + React 19 + TailwindCSS v4.
- **Features**:
    - Dashboard with user profile + active accounts.
    - Accounts page (create, view, link to transactions).
    - Transactions page (view, create new).
    - Money Transfer page (sender/recipient accounts, double-entry).
    - Error Reporting page (stacktrace trimmed to 5 lines).
    - Account Holders management (add/remove, role types).
    - Statements view (dynamic by date range).
    - Cards (ship new card, digital card UI).
- **UI/UX**:
    - Neon-inspired palette for modern banking feel (inspired by Robinhood).
    - Transaction rows alternate light/dark shading.
    - Suspense boundaries fixed for useSearchParams issues.

## Dockerization
- **Multi-stage builds** for backend & frontend.
- Issues encountered & solved:
    - `.next` not copied → fixed by proper `COPY --from=builder`.
    - `pnpm-lock.yaml` mismatch → aligned lockfiles in root/frontend.
    - `.env` handling → moved from `COPY` into `Makefile`-driven `--env-file` injection.
    - DB persistence: mounted `./data` for prod, tmpfs for dev/test.
- **Makefile Targets**:
    - `make dev` → dev docker-compose.
    - `make up` → prod docker-compose.
    - `make db-rev`, `make db-upgrade`, `make seed` helpers.

## Final Polish
- **Docs**:
    - `README.md`: project overview, run instructions, env vars, Docker usage.
    - `ONBOARDING.md`: step-by-step setup guide for new developers.
- **Styling**:
    - Tailwind global.css refined with neon palette, alternating row backgrounds.
    - Calendar/date input restyled for visibility.
- **Testing (Frontend)**:
    - Vitest + React Testing Library + JSDOM.
    - Clerk + API fully mocked for isolated tests.

---

# Part 2: Raw Transcript Appendices

Below is the verbatim log of the entire conversation between Developer (user) and AI (assistant).  
For brevity in this export, only **sample excerpts** are included – the full transcript is available separately.

---

## Appendix A – Backend Build & Models
```plaintext
[user]: Amazing suggestions, that works! Let's move on to the next step
[assistant]: Great, next we’ll add a transaction create endpoint + UI…
[user]: Nice, I just needed to complete step 1 and that resolved my issue...
...
```

## Appendix B – Testing & Fixtures
```plaintext
[user]: When running the tests with `poetry run pytest -v` I receive this error...
[assistant]: That means pytest cannot resolve the `app` module, let’s fix sys.path in conftest.py...
[user]: Ok I changed some things so now the basic test is passing...
...
```

## Appendix C – Frontend UI/UX
```plaintext
[user]: ok this looks better. The view transactions button is not working properly...
[assistant]: Let’s scaffold a dedicated /accounts/[id] detail page…
[user]: Wow, amazing we went from nothing just a few days ago to a full fledged MVP...
...
```

## Appendix D – Dockerization Issues
```plaintext
[user]: The docker file is still not working for the frontend application...
[assistant]: Try adjusting COPY paths, remember pnpm-lock.yaml location matters...
[user]: Amazing job, together we resolved all the docker issues...
...
```

---

# End of Hybrid Export
