@echo off
chcp 65001 >nul
title Portfolio Deploy

:: ══════════════════════════════════════════════════════════════
::  PORTFOLIO AUTO-DEPLOY
::  GitHub push → Vercel production deploy
::
::  [사전 설치 필요]
::  1. Git          https://git-scm.com/download/win
::  2. Node.js      https://nodejs.org  (LTS)
::  3. Vercel CLI   npm i -g vercel
::  4. 최초 1회:   vercel login
::                  vercel link   (프로젝트 루트에서)
:: ══════════════════════════════════════════════════════════════

echo.
echo  ┌─────────────────────────────────────────┐
echo  │   PORTFOLIO — AUTO DEPLOY               │
echo  │   GitHub ^& Vercel                       │
echo  └─────────────────────────────────────────┘
echo.

:: ── 커밋 메시지 입력 ──────────────────────────────────────────
set /p COMMIT_MSG="Commit message (Enter = 'update'): "
if "%COMMIT_MSG%"=="" set COMMIT_MSG=update

:: ── Git 상태 확인 ─────────────────────────────────────────────
echo.
echo [1/4] Checking Git status...
git status --short
if %errorlevel% neq 0 (
    echo.
    echo  ERROR: Git not found or not a git repository.
    echo  Run 'git init' first.
    pause
    exit /b 1
)

:: ── Git add + commit + push ───────────────────────────────────
echo.
echo [2/4] Git add...
git add -A
if %errorlevel% neq 0 goto :git_error

echo.
echo [3/4] Git commit: "%COMMIT_MSG%"
git commit -m "%COMMIT_MSG%"
:: commit이 nothing to commit이어도 계속 진행
echo.
echo [3/4] Git push...
git push
if %errorlevel% neq 0 goto :git_error

:: ── Vercel deploy ─────────────────────────────────────────────
echo.
echo [4/4] Vercel production deploy...
echo.
vercel --prod --yes
if %errorlevel% neq 0 goto :vercel_error

:: ── 완료 ──────────────────────────────────────────────────────
echo.
echo  ┌─────────────────────────────────────────┐
echo  │   DEPLOY COMPLETE                       │
echo  └─────────────────────────────────────────┘
echo.
goto :end

:git_error
echo.
echo  ERROR: Git push failed.
echo  Check your remote URL:  git remote -v
echo  Or authenticate:        gh auth login
echo.
pause
exit /b 1

:vercel_error
echo.
echo  ERROR: Vercel deploy failed.
echo  Try:  vercel login
echo        vercel link
echo.
pause
exit /b 1

:end
echo  Press any key to close...
pause >nul