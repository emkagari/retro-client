@echo off
rem The project's tools in Docker: nothing to install but Docker Desktop (Windows).
rem
rem   retro build                 src/ -> build\loader.swf
rem   retro play                  build, package from your official client, start the game
rem   retro dev                   the same with hot reload and auto login (close the watcher window to stop)
rem   retro release v1.49.5-r1    prepare a release (dist\release\)
rem   retro help                  every command
rem
rem The image (Node, Java, FFDec) is built on first use, and again when the
rem Dockerfile changes. The repository is mounted at /work; your official client
rem (retro.local.json's "upstream.windows") at /upstream/windows. The game runs here.
setlocal enabledelayedexpansion
cd /d "%~dp0"
set IMAGE=retro-client
set PLATFORM=windows

docker build -q -t %IMAGE% . >nul || exit /b 1

rem The official client, from retro.local.json.
set UPSTREAM=
if exist retro.local.json (
  for /f "usebackq delims=" %%u in (`docker run --rm -v "%CD%:/work" --entrypoint node %IMAGE% -e "try { process.stdout.write(require('/work/retro.local.json').upstream?.windows ?? '') } catch {}"`) do set UPSTREAM=%%u
)
set MOUNTS=
if defined UPSTREAM set MOUNTS=-v "%UPSTREAM%:/upstream/windows:ro" -e RETRO_UPSTREAM_WINDOWS=/upstream/windows

set CLIENT=dist\%PLATFORM%

if /i "%~1"=="play" goto play
if /i "%~1"=="dev" goto dev
docker run --rm -it -v "%CD%:/work" %MOUNTS% %IMAGE% %*
exit /b %errorlevel%

:play
docker run --rm -it -v "%CD%:/work" %MOUNTS% %IMAGE% package --platform %PLATFORM% || exit /b 1
call :start
exit /b 0

:dev
set HOT=%CLIENT%\resources\app\retroclient\hot\version.txt
if exist "%HOT%" del "%HOT%"
shift
rem The watcher in its own window (close it to stop), the game once the first build is packaged.
start "retro dev" docker run --rm -it -v "%CD%:/work" %MOUNTS% %IMAGE% dev --platform %PLATFORM% --no-run %1 %2 %3
:wait
if exist "%HOT%" goto ready
timeout /t 1 /nobreak >nul
goto wait
:ready
call :start
exit /b 0

:start
rem The first .exe of the client folder (uninstallers and crash reporters aside).
for %%f in ("%CLIENT%\*.exe") do (
  echo %%~nxf | findstr /i "unins crash" >nul || (start "" "%%f" & exit /b 0)
)
echo no executable found in %CLIENT%
exit /b 1
