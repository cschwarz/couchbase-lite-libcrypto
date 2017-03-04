@echo off

setlocal
call "%VS140COMNTOOLS%..\..\VC\vcvarsall.bat"

set OUTPUT_DIR="%CD%\libs\windows"
rmdir /S /Q %OUTPUT_DIR%

cd vendor\microsoft-openssl
call git clean -dfx
call git checkout -f

call ms\do_vsprojects14.bat
call msbuild vsout\openssl.sln /t:NT-Universal-10_0-Static-Unicode /p:Configuration="Release" /p:Platform="x86"
call msbuild vsout\openssl.sln /t:NT-Universal-10_0-Static-Unicode /p:Configuration="Release" /p:Platform="x64"
call msbuild vsout\openssl.sln /t:NT-Universal-10_0-Static-Unicode /p:Configuration="Release" /p:Platform="ARM"

mkdir %OUTPUT_DIR%\x86
mkdir %OUTPUT_DIR%\amd64
mkdir %OUTPUT_DIR%\x86_64
mkdir %OUTPUT_DIR%\arm
copy vsout\NT-Universal-10.0-Static-Unicode\Release\Win32\bin\libeay32.lib %OUTPUT_DIR%\x86
copy vsout\NT-Universal-10.0-Static-Unicode\Release\x64\bin\libeay32.lib %OUTPUT_DIR%\amd64
copy vsout\NT-Universal-10.0-Static-Unicode\Release\x64\bin\libeay32.lib %OUTPUT_DIR%\x86_64
copy vsout\NT-Universal-10.0-Static-Unicode\Release\arm\bin\libeay32.lib %OUTPUT_DIR%\arm

call git clean -dfx
call git checkout -f

:: Exit
cd ..\..\
endlocal