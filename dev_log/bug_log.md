# Bug Log

A log of all errors, warnings, and technical issues encountered during development. Each entry includes a timestamp (UTC), context, error message, analysis, status, and actions taken.

---

[2024-06-27 14:32:00 UTC]
Context: Attempt to run the app on Windows (from wrong directory)
Error:
'.\build\windows\x64\runner\Debug\ploi_api_app.exe' is not recognized as the name of a cmdlet, function, script file, or operable program. Check the spelling of the name, or if a path was included, verify that the path is correct and try again.
Analysis: The terminal was not in the correct directory, or the file did not exist or was not built.
Status: Unresolved
Actions: Performed cd to the correct directory, rebuilt the app, but the issue persisted.

---

[2024-06-27 14:35:00 UTC]
Context: Attempt to run the app in Chrome
Error:
Flutter failed to delete a directory at "build\flutter_assets". The flutter tool cannot access the file or directory. Please ensure that the SDK and/or project is installed in a location that has read/write permissions for the current user.
Analysis: The build directory or files are locked, possibly by another process (e.g., Chrome, VSCode, or Dart Analysis). This is a common issue on Windows when files are in use.
Status: Unresolved
Actions: Tried to close all related processes, manually delete the directory, and run flutter clean, but the error persists.

---

[2024-06-27 14:45:00 UTC]
Context: Attempt to run the app on Windows, but the process may be stuck or not visible.
Error:
No visible app window, and process not found in Get-Process output. Previous attempts to run the .exe failed with 'is not recognized as the name of a cmdlet...'.
Analysis: The app may be stuck, not started, or terminated unexpectedly. There may be a zombie process or a path issue.
Status: In progress
Actions: Will attempt to kill any existing ploi_api_app process and restart the app, then log the result.

---

[2024-06-27 14:48:00 UTC]
Context: Repeatedly tried to use '&&' in PowerShell to chain commands (cd and Start-Process), which is not supported in Windows PowerShell.
Error:
The token '&&' is not a valid statement separator in this version.
Analysis: This is a recurring mistake. PowerShell does not support '&&' for chaining commands; each command must be run separately. This caused the app not to launch.
Status: Resolved (workflow)
Actions: Will always run directory change and process start as two separate commands from now on. Committed to not repeating this mistake.

---

[2024-06-27 15:10:00 UTC]
Context: Version bump after implementing automatic runtime error logging to bug_log.txt
Change: Version updated from 1.00 to 1.01 in all relevant files (README, AppBar, logs)
Reason: Every code change requires a version increment according to the project's versioning policy.
Status: Completed

---

[2024-06-27 15:20:00 UTC]
Context: Version bump after unifying all error logging to bug_log.txt (including API/server errors).
Change: Version updated from 1.01 to 1.02 in all relevant files (README, AppBar, logs)
Reason: All errors and warnings are now logged to a single file for easier tracking and debugging.
Status: Completed

---

[2024-06-27 15:40:00 UTC]
Context: Version bump after automatic fixing of all flutter analyze issues as part of full run (הרצה מלאה).
Change: Version updated from 1.02 to 1.03 in all relevant files (README, AppBar, logs)
Reason: All flutter analyze issues are now fixed automatically before build and run.
Status: Completed
--- 