@echo off
echo.
echo ========================================
echo   EasyLive App - Flutter Runner
echo ========================================
echo.
echo PENTING: Anda perlu kredensial Supabase untuk menjalankan aplikasi.
echo.
echo Jika Anda belum punya kredensial:
echo 1. Hubungi anggota tim yang mengelola backend Supabase
echo 2. Minta SUPABASE_URL dan SUPABASE_ANON_KEY
echo 3. Edit file run.bat ini dan ganti nilai di bawah:
echo.
echo Contoh format:
echo   SUPABASE_URL = https://xxxxx.supabase.co
echo   SUPABASE_ANON_KEY = eyxxxxx...xxxxx
echo.
echo ========================================
echo.

REM ==================== EDIT DI BAWAH INI ====================
SET SUPABASE_URL=https://GANTI_DENGAN_URL_SUPABASE_ANDA.supabase.co
SET SUPABASE_ANON_KEY=GANTI_DENGAN_ANON_KEY_ANDA
REM =============================================================

IF "%SUPABASE_URL%"=="https://GANTI_DENGAN_URL_SUPABASE_ANDA.supabase.co" (
    echo [ERROR] Kredensial Supabase belum diatur!
    echo.
    echo Silakan edit file run.bat ini dan ganti:
    echo   - SUPABASE_URL dengan URL project Supabase Anda
    echo   - SUPABASE_ANON_KEY dengan anon key dari Supabase
    echo.
    echo Cara mendapatkan kredensial:
    echo 1. Buka https://supabase.com
    echo 2. Pilih project Anda
    echo 3. Masuk ke Settings ^> API
    echo 4. Copy "Project URL" dan "anon/public" key
    echo.
    pause
    exit /b 1
)

echo [INFO] Menyiapkan build dengan konfigurasi Supabase...
echo [INFO] URL: %SUPABASE_URL%
echo [INFO] Key: %SUPABASE_ANON_KEY%
echo.

cd /d "%~dp0"

echo [INFO] Membersihkan build sebelumnya...
call flutter clean
echo.

echo [INFO] Mendapatkan dependencies...
call flutter pub get
echo.

echo [INFO] Menjalankan aplikasi...
echo.
flutter run --dart-define=SUPABASE_URL="%SUPABASE_URL%" --dart-define=SUPABASE_ANON_KEY="%SUPABASE_ANON_KEY%"

IF ERRORLEVEL 1 (
    echo.
    echo [ERROR] Gagal menjalankan aplikasi. Periksa kredensial Supabase Anda.
    pause
)