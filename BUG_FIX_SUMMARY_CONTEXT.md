# Bug Fix: Dialog Context Error

## Issue
The error "Looking up a deactivated widget's ancestor is unsafe" occurred because `ScaffoldMessenger.of(context)` was being called inside a dialog AFTER the dialog was closed (`Navigator.pop`). 

The variable `context` inside the dialogs was referring to the **dialog's internal context** (shadowing the parent context). When the dialog closes, this internal context is deactivated/unmounted. Trying to use it to find the Scaffold (ancestor) causes the crash.

## Fix
I renamed the internal context variable in all `StatefulBuilder` widgets (used for the progress indicator logic) from `context` to `sbContext`.

Now, `ScaffoldMessenger.of(context)` correctly refers to the **outer parent context** (the Dashboard screen), which remains active and stable even after the dialog closes.

## Affected Areas Fixed
1. `_showCreateDialog` (Program/Course creation)
2. `_showCreateClassDialog` (Class creation)
3. `ProgramDetailScreen` FAB (Add Course to Program)
4. `CourseDetailScreen` FAB (Add Class to Course)
5. `_showAddSessionDialog` (Live Session)

## Action Required
Please perform a **Hot Restart** (`Shift + R` in your terminal) to ensure the dialogs use the updated code.
