@echo off
rem The project's tools in Docker: nothing to install but Docker Desktop (Windows).
rem
rem   retro build                 src/ -> build\loader.swf
rem   retro play                  build, package from your official client, start the game
rem   retro dev                   the same with hot reload and auto login (Ctrl+C to stop)
rem   retro release v1.49.5-r1    prepare a release (dist\release\)
rem   retro help                  every command
rem
rem The image (Node, Java, FFDec) is built on first use, and again when the
rem Dockerfile changes. The repository is mounted at /work; your official client
rem (retro.local.json's "upstream.windows") at /upstream/windows, your local overlay
rem ("overlay") at /overlay. The game runs here.
setlocal enabledelayedexpansion
cd /d "%~dp0"
rem This script's path, before any shift (shift moves %0 too).
set SELF=%~f0
set IMAGE=retro-client
set PLATFORM=windows
set CLIENT=dist\%PLATFORM%
set HOT=%CLIENT%\resources\app\retroclient\hot\version.txt
if "%~1"==":waitgame" goto waitgame

docker build -q -t %IMAGE% . >nul || exit /b 1

rem The official client and the local overlay, from retro.local.json.
set UPSTREAM=
set OVERLAY=
if exist retro.local.json (
  for /f "usebackq delims=" %%u in (`docker run --rm -v "%CD%:/work" --entrypoint node %IMAGE% /work/tools/local.mjs upstream.windows`) do set UPSTREAM=%%u
  for /f "usebackq delims=" %%u in (`docker run --rm -v "%CD%:/work" --entrypoint node %IMAGE% /work/tools/local.mjs overlay`) do set OVERLAY=%%u
)
set MOUNTS=
if defined UPSTREAM set MOUNTS=-v "%UPSTREAM%:/upstream/windows:ro" -e RETRO_UPSTREAM_WINDOWS=/upstream/windows
if defined OVERLAY set MOUNTS=%MOUNTS% -v "%OVERLAY%:/overlay:ro" -e RETRO_OVERLAY=/overlay

if /i "%~1"=="play" goto play
if /i "%~1"=="dev" goto dev
docker run --rm -it -v "%CD%:/work" %MOUNTS% %IMAGE% %*
exit /b %errorlevel%

:play
docker run --rm -it -v "%CD%:/work" %MOUNTS% %IMAGE% package --platform %PLATFORM% || exit /b 1
call :startgame
exit /b %errorlevel%

:dev
if exist "%HOT%" del "%HOT%"
shift
set NAME=retro-dev-%RANDOM%
rem The watcher runs here (Ctrl+C to stop); a waiter in the background starts
rem the game once the first build is packaged. The first run copies the
rem official client into dist\windows (about 700 MB): a few minutes.
start "" /b cmd /c call "%SELF%" :waitgame %NAME%
docker run --rm -it --name %NAME% -v "%CD%:/work" %MOUNTS% %IMAGE% dev --platform %PLATFORM% --no-run %1 %2 %3
exit /b %errorlevel%

:waitgame
rem Until the watcher writes the first version.txt; gives up once it has stopped.
set /a WAITED=0
:waitloop
if exist "%HOT%" goto waitdone
ping -n 3 127.0.0.1 >nul
set /a WAITED+=2
docker inspect %2 >nul 2>&1 && goto waitloop
rem Not running: not started yet (30 s to do it), or stopped.
if %WAITED% lss 30 goto waitloop
exit /b 1
:waitdone
call :startgame
exit /b %errorlevel%

:startgame
rem The first .exe of the client folder (uninstallers and crash reporters aside).
for %%f in ("%CLIENT%\*.exe") do (
  echo %%~nxf | findstr /i "unins crash" >nul || (start "" "%%f" & exit /b 0)
)
echo no executable found in %CLIENT%
exit /b 1
