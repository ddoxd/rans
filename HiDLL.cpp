#include <windows.h> // Required for MessageBox and DLL entry point

// This is the standard entry point for a DLL.
// For this simple demo, we don't need to do anything special here.
BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
                     )
{
    switch (ul_reason_for_call)
    {
    case DLL_PROCESS_ATTACH:
        // Code to run when the DLL is loaded into a process
        break;
    case DLL_THREAD_ATTACH:
        // Code to run when a new thread is created in the loading process
        break;
    case DLL_THREAD_DETACH:
        // Code to run when a thread is exiting cleanly
        break;
    case DLL_PROCESS_DETACH:
        // Code to run when the DLL is unloaded from a process
        break;
    }
    return TRUE; // Indicate success
}

// This is our exported function that rundll32.exe will call.
// extern "C" prevents C++ name mangling, making it easier for rundll32 to find.
// __declspec(dllexport) marks the function for export from the DLL.
// CALLBACK is a calling convention (stdcall) often used for Windows API callbacks.
extern "C" __declspec(dllexport) void CALLBACK ShowGreeting(
    HWND hwnd,        // Handle to owner window (can be NULL)
    HINSTANCE hinst,  // Handle to DLL module instance
    LPSTR lpszCmdLine, // Command line string (arguments passed after function name)
    int nCmdShow      // Show state (not really used for a simple message box)
)
{
    // The main action: Display a message box!
    MessageBox(
        NULL,                           // No owner window
        L"HI FROM THE DLL!\n\nPretty cool, huh? You called me!", // Message text (L"" for wide string)
        L"DLL Bragging Rights!",        // Title of the message box
        MB_OK | MB_ICONINFORMATION     // OK button and an information icon
    );
}

// You could add another function just for fun:
extern "C" __declspec(dllexport) void CALLBACK AnotherFunction(HWND hwnd, HINSTANCE hinst, LPSTR lpszCmdLine, int nCmdShow)
{
    MessageBox(NULL, L"You called AnotherFunction!\nParams: ", lpszCmdLine, MB_OK);
}
