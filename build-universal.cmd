@echo off

:: OPENSSL Configuration Options
set /p OPENSSL_CONFIG_OPTIONS=<config-params-windows.txt

:: Output Directory
set OUTPUT_DIR="%CD%\libs\windows"

:: Clean output directory
rmdir /S /Q %OUTPUT_DIR%

cd vendor\microsoft-openssl

set MAKE_OUTPUT_DIR="%CD%\out32"

call git clean -dfx
call git checkout -f

:: Configure and make
perl Configure VC-WINUNIVERSAL no-hw no-dso %OPENSSL_CONFIG_OPTIONS%
call ms\do_winuniversal.bat
call ms\setVSvars universal10.0x86
nmake -f ms\nt.mak init
nmake -f ms\nt.mak

:: Copy binary
mkdir %OUTPUT_DIR%\x86
copy %MAKE_OUTPUT_DIR%\libeay32.lib %OUTPUT_DIR%\x86

:: Reset and done
call git clean -dfx
call git checkout -f

:: Configure and make
perl Configure VC-WINUNIVERSAL no-hw no-dso %OPENSSL_CONFIG_OPTIONS%
call ms\do_winuniversal.bat
call ms\setVSvars universal10.0x64
nmake -f ms\nt.mak init
nmake -f ms\nt.mak

:: Copy binary
mkdir %OUTPUT_DIR%\amd64
copy %MAKE_OUTPUT_DIR%\libeay32.lib %OUTPUT_DIR%\amd64

mkdir %OUTPUT_DIR%\x86_64
copy %MAKE_OUTPUT_DIR%\libeay32.lib %OUTPUT_DIR%\x86_64

:: Reset and done
REM call git clean -dfx
REM call git checkout -f

:: Exit
cd ..\..\