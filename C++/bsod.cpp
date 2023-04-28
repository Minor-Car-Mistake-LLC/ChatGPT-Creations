// THIS SCRIPT WILL BSOD YOUR PC
// Made by [Google's Bard](https://bard.google.com/)

#include <windows.h>

int main() {
  NTSTATUS(WINAPI *NtTerminateProcess)(HANDLE ProcessHandle, NTSTATUS ExitStatus);
  NtTerminateProcess = (NTSTATUS(WINAPI *)(HANDLE, NTSTATUS))GetProcAddress(GetModuleHandle("ntdll.dll"), "NtTerminateProcess");

  NtTerminateProcess(GetCurrentProcess(), 0x000000ED);

  return 0;
}
