set LIBCLANG_PATH=C:\src\llvm-18\bin
set CC=C:\src\llvm-18\bin\clang-cl.exe
set AR=C:\src\llvm-18\bin\llvm-ar.exe
@REM if the above didn't work, edit and add new system environment variables 
@REM directly and open up the new cmd.
cargo build --release
copy target\release\h26forge.exe .