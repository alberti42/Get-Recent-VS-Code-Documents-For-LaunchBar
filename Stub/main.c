// RecentVSCodeDocuments — the executable of Recent VS Code Opened Files.lbaction.
//
// LaunchBar does not run this program; it runs Contents/Scripts/default.py.
// The program exists so that the bundle has Mach-O code: signing the bundle
// embeds the signature, which seals default.py, in this executable, and
// Apple's notary service issues tickets only for Mach-O code. Without it,
// Gatekeeper rejects the downloaded action ("Apple could not verify ... is
// free of malware").

#include <stdio.h>

int main(void)
{
    fputs("Recent VS Code Opened Files: LaunchBar runs Contents/Scripts/default.py; "
          "this program does nothing.\n", stderr);
    return 0;
}
