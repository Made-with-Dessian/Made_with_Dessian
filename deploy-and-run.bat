@echo off
chcp 65001 > nul
title Portfolio — Deploy & Run

echo.
echo  ┌─────────────────────────────────────────┐
echo  │  PORTFOLIO — AUTO DEPLOY                │
echo  │  Git push + Vercel + Local dev server   │
echo  └─────────────────────────────────────────┘
echo.

cd /d C:\Users\gimwo\Desktop\portfolio

:: ── 1. Git status check ─────────────────────────────────────
echo [1/4] Checking git status...
git status --short
echo.

:: ── 2. Stage all public HTML files ──────────────────────────
echo [2/4] Staging files...
git add public\*.html
git add public\images\

:: ── 3. Commit with timestamp ─────────────────────────────────
for /f "tokens=1-3 delims=/ " %%a in ("%date%") do set D=%%a-%%b-%%c
for /f "tokens=1-2 delims=: " %%a in ("%time%") do set T=%%a:%%b
git commit -m "Update portfolio — %D% %T%"

:: ── 4. Push to GitHub → triggers Vercel auto-deploy ─────────
echo [3/4] Pushing to GitHub...
git push origin main

if %errorlevel% neq 0 (
  echo.
  echo  [!] Git push failed. Check your connection or credentials.
  echo.
  pause
  exit /b 1
)

echo.
echo  [OK] Pushed. Vercel will auto-deploy in 1-2 minutes.
echo  URL: https://made-with-dessian-git-main-wvwf4tbvv6-9973s-projects.vercel.app
echo.

:: ── 5. Start local dev server ─────────────────────────────────
echo [4/4] Starting local dev server...
echo  Local:  http://localhost:3000/home-prototype-v2-linked.html
echo  Portfolio: http://localhost:3000/portfolio-index.html
echo.
echo  Press Ctrl+C to stop the server.
echo.

npm run dev

pause
