@echo off
setlocal

set "BLENDER_EXE=C:\Program Files\Blender Foundation\Blender 4.2\blender.exe"
set "PROJECT_DIR=%~dp0"
set "SCRIPT=%PROJECT_DIR%scripts\main.py"

if not exist "%BLENDER_EXE%" (
  echo Blender executable not found:
  echo %BLENDER_EXE%
  echo.
  echo Edit BLENDER_EXE in render_local.bat and run again.
  exit /b 1
)

"%BLENDER_EXE%" --background --python "%SCRIPT%" --render-anim
endlocal
