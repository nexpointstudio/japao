@echo off
cd /d "%~dp0"
where py >nul 2>nul
if %errorlevel%==0 (
  set "PY=py"
) else (
  set "PY=python"
)
start "Amahara Server" /min cmd /c "%PY% -m http.server 8000"
timeout /t 1 /nobreak >nul
start "" http://localhost:8000
exit
