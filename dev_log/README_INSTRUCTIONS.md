# הוראות התמצאות בפרויקט - ploi_api_app
===============================================

## 🤖 הוראות פנימיות לעוזר (AI Assistant Instructions)

### 📅 תהליך תיעוד ובדיקת תאריך/שעה
**לפני כל פעולה מהותית (תיעוד, הרצה, שינוי קוד):**
1. **בדוק תאריך/שעה מדויקים** מול שרת Google/Microsoft (UTC)
2. **תעד כל שלב** עם חותמת זמן מדויקת
3. **צטט את ה-PROMPT** של המשתמש
4. **תאר את הפעולה/בעיה/פתרון**

### 📝 פורמט תיעוד
```
[YYYY-MM-DD HH:MM:SS UTC]
PROMPT: "ציטוט מדויק של ה-PROMPT של המשתמש"
פעולה: תיאור הפעולה שביצעת
תוצאה: מה קרה/מה השתנה
בעיות: אם היו בעיות ופתרונות
```

### 🔧 טיפול בבעיות הרשאות (Windows/Flutter)
**כאשר נתקלים בשגיאות הרשאות:**
1. **סגור תהליכים פתוחים** (Chrome, VSCode, Dart Analysis)
2. **ודא עבודה מתוך התיקייה הנכונה** (Projects/ploi_api_app)
3. **הפעל PowerShell/CMD כ-Administrator** במידת הצורך
4. **מחק ידנית** תיקיות build, .dart_tool, build/web
5. **תעד כל ניסיון** - גם אם נכשל

### 🔄 תהליך Git ו-Repository (חובה בתחילת כל עבודה!)

**בתחילת כל יום עבודה:**
1. **מעבר לתיקיית הפרוייקט:**
   ```powershell
   cd Projects/ploi_api_app
   ```

2. **בדיקת סטטוס Git:**
   ```powershell
   git status
   ```

3. **משיכת עדכונים מ-GitHub:**
   ```powershell
   git pull origin master
   ```

4. **בדיקת שינויים ניתן למיזוג:**
   ```powershell
   git log --oneline -5
   ```

**בסוף כל יום עבודה או אחרי פיצ'ר מוכן:**
1. **הוספת קבצים לGit:**
   ```powershell
   git add .
   ```

2. **בדיקת מה יועלה:**
   ```powershell
   git status
   ```

3. **Commit עם הודעה ברורה:**
   ```powershell
   git commit -m "תיאור ברור של השינוי בעברית ו-English"
   ```

4. **העלאה ל-GitHub:**
   ```powershell
   git push origin master
   ```

**הוראות Git חשובות:**
- **לא לעשות commit** אם יש שגיאות או קוד לא עובד
- **תמיד לבדוק** `flutter analyze` לפני commit
- **הודעות commit** צריכות להיות ברורות ומתארות מה השתנה
- **Push יומי** - בסוף כל יום עבודה
- **Repository URL:** https://github.com/noambroner/ploi-api-app

### 🎯 תהליך עבודה מסודר
1. **קרא את הקובץ הזה** (README_INSTRUCTIONS.md)
2. **בדוק תאריך/שעה** לפני כל פעולה
3. **בצע Git pull** לעדכון מהרפוזיטורי
4. **ודא עבודה בתיקייה הנכונה** - תמיד עבוד מתוך Projects/ploi_api_app
5. **תעד כל שלב** מיידית
6. **בדוק תוצאות** לפני המשך
7. **Commit ו-Push** בסוף העבודה

### 📋 הוראות פיתוח
- **שפת עבודה עיקרית:** עברית (אלא אם המשתמש מבקש אחרת)
- **תיעוד דו-לשוני:** עברית ואנגלית לפי הצורך
- **קוד איכותי:** flutter analyze לפני כל commit
- **בדיקות:** בדוק תמיד שהאפליקציה רצה לפני המשך

### ⚠️ הוראות חשובות ל-Windows
**בתחילת כל סשן פיתוח:**
1. **ודא שאתה בתיקייה הנכונה:** `cd Projects/ploi_api_app`
2. **אל תשתמש ב-&& ב-Windows PowerShell** - השתמש בפקודות נפרדות
3. **בדוק את ה-working directory** לפני כל פקודה
4. **אם הטרמינל חזר לתיקייה אחרת** - נווט חזרה לתיקייה הנכונה

**דוגמה נכונה ל-Windows:**
```powershell
cd Projects/ploi_api_app
flutter doctor
flutter clean
flutter pub get
```

**דוגמה שגויה (לא עובד ב-Windows):**
```powershell
cd Projects/ploi_api_app && flutter doctor  # ❌ לא עובד
```

### 📦 Versioning & Version Management Rules
- The current version of the project is: **1.2.9**
- **CRITICAL RULE:** Every code change MUST update the version number according to semantic versioning:
  - **Bug fixes** = patch version (x.x.X) - e.g., 1.2.0 → 1.2.1
  - **New features** = minor version (x.X.x) - e.g., 1.2.1 → 1.3.0
  - **Breaking changes** = major version (X.x.x) - e.g., 1.3.0 → 2.0.0

- **MANDATORY UPDATES:** After every change, update:
  1. **AppBar title** in main.dart: `'Ploi API Dashboard vX.X.X'`
  2. **pubspec.yaml** version field: `version: X.X.X+buildNumber`
  3. **This README file** current version number
  4. **All development logs** with the new version

- **Version Tracking Purpose:**
  - Ensures the correct code is loaded when running the app
  - Allows tracking which features/fixes are in each build
  - Prevents confusion about which version is running
  - Essential for debugging and user support

- **Example Version History:**
  - v1.2.0: Added home button to main screen
  - v1.2.1: Fixed home button visibility in server management screen

**❗ NO EXCEPTIONS:** Every single code change = version update. This is not optional!

---

## 🕒 בדיקת תאריך ושעה לפני תיעוד
לפני כל תיעוד ביומן פיתוח (dev_steps), יש לבדוק את התאריך והשעה המדויקים (רצוי עם גוגל) ולוודא שהם נכונים גם בכותרת וגם בשם הקובץ!

## 🎯 מטרת הקובץ
הקובץ הזה מרכז את כל המידע הדרוש להתמצאות, תיעוד, המשך פיתוח ותחזוקה של אפליקציית ploi_api_app (פאנל ניהול ל-Ploi API).

---

## 📁 יומני פיתוח וקבצי הוראות
- **קובץ הוראות עיקרי:** `DEVELOPMENT_WORKFLOW_INSTRUCTIONS.md` - קרא תמיד!
- **יומני פיתוח:** תיקיית `dev_log/dev_steps/`
- **פורמט יומני פיתוח:** `dev_steps_{DD.MM.YY}_he.txt` ו-`dev_steps_{DD.MM.YY}_en.txt`
- **כל קובץ מתעד:** מה עשינו, בעיות, סטטוס, צעדים הבאים - בעברית ובאנגלית

---

## 🔄 תהליך התמצאות (כל פעם שנכנסים לפרויקט)
1. קרא את הקובץ הזה (`README_INSTRUCTIONS.md`)
2. **קרא את `DEVELOPMENT_WORKFLOW_INSTRUCTIONS.md` - חובה!**
3. סרוק את יומני הפיתוח (אם קיימים)
4. זהה מה הסטטוס הנוכחי ומה הצעדים הבאים

---

## 📋 מידע על הפרויקט (תקציר)

### מה זה הפרויקט?
**ploi_api_app** - אפליקציית Flutter Desktop/Web לניהול שרתים, אתרים, ניטור וגיבויים דרך Ploi API.

### מבנה הפרויקט:
```
Projects/
└── ploi_api_app/
    ├── lib/
    │   ├── main.dart
    │   └── ...
    ├── assets/
    │   ├── images/
    │   ├── icons/
    │   └── locales/   # קבצי תרגום
    ├── dev_log/      # יומני פיתוח (אם יש)
    ├── README_INSTRUCTIONS.md
    └── ...
```

### טכנולוגיות:
- **Frontend:** Flutter Desktop/Web (ריבוי שפות, RTL, Material Design)
- **API:** חיבור ל-Ploi API (ניהול שרתים, אתרים, ניטור, גיבויים)
- **State Management:** Provider/Riverpod
- **Storage:** SharedPreferences/Hive

---

## 🚀 פקודות חשובות

### הרצת האפליקציה:
```bash
cd Projects/ploi_api_app
flutter run -d chrome      # להרצה בדפדפן
flutter run -d windows     # להרצה כאפליקציית דסקטופ (דורש Visual Studio)
```

### דרישות להרצה על Windows:
⚠️ **חשוב:** להרצה על Windows נדרשים:
1. **Developer Mode** - יש להפעיל בהגדרות Windows (Settings > Update & Security > For developers)
2. **Visual Studio** - עם רכיב "Desktop development with C++" (לא VS Code!)
3. **הפעלה מחדש** של המערכת לאחר ההתקנה

### פתרון בעיות נפוצות:
1. **בעיית הרשאות build/ או flutter_assets**
   - סגור דפדפנים/VSCode, מחק ידנית את build/, הרץ `flutter clean`
2. **Firefox לא מזוהה**
   - ודא ש-Firefox מותקן, הרץ `flutter devices`
3. **בעיות תלויות**
   - הרץ `flutter pub get` ו-`flutter pub upgrade`
4. **שגיאת symlink ב-Windows**
   - הפעל Developer Mode בהגדרות Windows
5. **שגיאת Visual Studio toolchain**
   - התקן Visual Studio Community עם "Desktop development with C++"

---

## 📝 איך לתעד לוגים

1. צור תיקיית `dev_log/dev_steps/`
2. כל סשן פיתוח → קובץ חדש לפי תאריך
3. תעד: מה עשית, בעיות, סטטוס, צעדים הבאים

### דוגמה:
```
PROMPT: "הוספת תמיכה ב-RTL וריבוי שפות"
----------------------------------------
- מה עשיתי: ...
- תוצאות: ...
- בעיות: ...
סטטוס:
- ✅ מה עובד
- ❌ מה לא עובד
- 🔄 מה בתהליך
```

---

## 🎯 מטרות הפרויקט (זכור תמיד)

### מטרה ראשית:
**לספק פאנל ניהול נוח, מהיר ומאובטח ל-Ploi API בדסקטופ/ווב**

### עקרונות מנחים:
1. **UI נוח ומודרני** (Material, RTL, רספונסיבי)
2. **ריבוי שפות** (עברית/אנגלית)
3. **אבטחה** (שמירת טוקן מאובטחת)
4. **קוד איכותי ומתועד**

### תכונות נוכחיות:
- ✅ דשבורד עם תפריט צד
- ✅ תמיכה ב-RTL וריבוי שפות
- ✅ מסך פרטי התחברות
- 🔄 חיבור ל-Ploi API
- 🔄 ניהול שרתים/אתרים/ניטור

### צעדים הבאים:
- פיתוח מסכי ניהול שרתים
- חיבור API אמיתי
- שיפור UI/UX

---

## ⚠️ הערות חשובות
1. **תעדכן לוגים בזמן אמת**
2. **שמור על קוד איכותי** (flutter analyze)
3. **עדכן תאריכים נכונים בלוגים**
4. **שפת עבודה עיקרית: עברית** (אלא אם המשתמש מבקש אחרת)

---

## 🆘 אם אני תקוע
1. קראתי את כל הלוגים?
2. הבנתי מה הסטטוס הנוכחי?
3. יש לי את כל הקונטקסט?
4. האם יש בעיות שחוזרות על עצמן?

### איך להגיב למשתמש:
1. "קראתי את הלוגים ומתעדכן..."
2. סכם מה עובד ומה לא
3. הצע צעדים ברורים
4. עדכן לוגים

---

**זכור: הקובץ הזה הוא המפתח להצלחה! תמיד תתחיל ממנו! 🔑**

## 📋 סקירה כללית / Overview

פרויקט Flutter לניהול שרתים דרך Ploi API עם תמיכה דו-לשונית (עברית/אנגלית).

A Flutter project for managing servers through Ploi API with bilingual support (Hebrew/English).

## 🗂️ מבנה תיעוד / Documentation Structure

### קבצי הוראות / Instruction Files
- `DEVELOPMENT_WORKFLOW_INSTRUCTIONS.md` - הוראות עבודה מפורטות לכל prompt
- `README_INSTRUCTIONS.md` - קובץ זה - סקירה כללית

### קבצי צעדים / Step Files
- `dev_steps/dev_steps_DD.MM.YY_he.txt` - תיעוד בעברית לכל session
- `dev_steps/dev_steps_DD.MM.YY_en.txt` - תיעוד באנגלית לכל session

## 📚 היסטוריה מלאה של הפרויקט / Complete Project History

### שלב 1: יצירת הפרויקט הראשוני / Phase 1: Initial Project Creation
- יצירת Flutter project עם תמיכה ב-web/desktop
- הגדרת תמיכה דו-לשונית (עברית/אנגלית)
- יצירת מבנה בסיסי של האפליקציה
- הוספת dependencies בסיסיות

### שלב 2: פיתוח UI מתקדם / Phase 2: Advanced UI Development
- שיפור Navigation Rail
- פיתוח ConnectionDetailsPage
- פיתוח ServersPage
- שיפור Theme ו-Design

### שלב 3: Mock Data Integration / Phase 3: Mock Data Integration
- יצירת Mock Data
- שיפור Error Handling
- בדיקות ראשוניות

### שלב 4: API Integration / Phase 4: API Integration (26.12.2024)
- יצירת PloiApiService
- החלפת Mock Data ב-Real API calls
- שיפור Translations
- בדיקות סופיות

## 🎯 סטטוס נוכחי / Current Status

✅ **הושלם / Completed:**
- פרויקט Flutter מלא עם תמיכה ב-web/desktop
- מערכת תרגומים דו-לשונית
- UI מלא עם navigation rail
- אינטגרציה מלאה עם Ploi API
- Error handling ו-loading states
- Responsive design
- Build מוכן לפריסה
- בדיקת סביבת Flutter והתלויות

⚠️ **חסום / Blocked:**
- הרצה על Windows - דורש הגדרות מערכת:
  - הפעלת Developer Mode
  - התקנת Visual Studio עם C++ desktop development tools

🔄 **בתהליך / In Progress:**
- הגדרת סביבת פיתוח Windows
- בדיקת הרצה על פלטפורמות שונות

## 📖 קבצי תיעוד זמינים / Available Documentation Files

### קבצי היסטוריה / History Files
- `dev_steps_26.12.24_he.txt` - תיעוד אינטגרציית API (עברית)
- `dev_steps_24.06.25_he.txt` - תיעוד היסטוריה מלאה (עברית)
- `dev_steps_24.06.25_en.txt` - תיעוד היסטוריה מלאה (אנגלית)

### קבצי הוראות / Instruction Files
- `DEVELOPMENT_WORKFLOW_INSTRUCTIONS.md` - הוראות עבודה מפורטות
- `README_INSTRUCTIONS.md` - קובץ זה

## 🚀 הפעלה / Running

```bash
cd Projects/ploi_api_app
flutter pub get
flutter build web
```

## 📝 הערות חשובות / Important Notes

- כל הצעדים הראשונים של הפרויקט מתועדים כעת
- ההיסטוריה המלאה זמינה בקבצי dev_steps
- כל עבודה עתידית חייבת לעקוב אחר הוראות ב-DEVELOPMENT_WORKFLOW_INSTRUCTIONS.md
- חובה לתעד כל prompt עם timestamp מדויק
- חובה ליצור תיעוד דו-לשוני לכל session

## 🔗 קישורים חשובים / Important Links

- [Ploi API Documentation](https://ploi.io/api-docs)
- [Flutter Documentation](https://flutter.dev/docs)
- [DEVELOPMENT_WORKFLOW_INSTRUCTIONS.md](./DEVELOPMENT_WORKFLOW_INSTRUCTIONS.md)

---

**⚠️ חשוב / Important:** כל עבודה עתידית חייבת לעקוב אחר ההוראות ב-`DEVELOPMENT_WORKFLOW_INSTRUCTIONS.md`!

## 🛠️ כללי קוד נקי / Clean Code Rules
- יש להריץ תמיד `flutter analyze` (או כלי אנליזה רלוונטי) לאחר כל שינוי.
- חובה לתקן כל שגיאה (error) או אזהרה (warning) עד שהקוד נקי לחלוטין.
- יש להקפיד על קוד יעיל, קריא, אחיד וללא קוד מת/לא בשימוש.
- אין להשאיר הדפסות debug (כגון print) בקוד פרודקשן.

- Always run `flutter analyze` (or relevant analyzer) after every change.
- All errors and warnings must be fixed before proceeding.
- Code must be clean, efficient, consistent, and free of dead/unused code.
- No debug prints (such as print) in production code.

**❗ אין לדלג על תיקון בעיות ואזהרות:**
- חובה לעצור ולטפל בכל שגיאה או אזהרה לפני המשך עבודה.
- אין להמשיך להרצה, פיתוח או תיעוד נוסף כל עוד קיימות בעיות.

**❗ Never skip fixing issues and warnings:**
- You must stop and resolve every error or warning before proceeding.
- Do not continue running, developing, or documenting while issues exist.

- Always run `flutter analyze` (or relevant analyzer) after every change.
- All errors and warnings must be fixed before proceeding.
- Code must be clean, efficient, consistent, and free of dead/unused code.
- No debug prints (such as print) in production code.

---

## 🐞 Bug Logging
- All errors and warnings (including API/server errors) are now logged to `dev_log/bug_log.txt` only.
- No more error_log.txt. All logs are unified for easier tracking.

---

## 📝 חובה: תיעוד אוטומטי בכל שינוי
- כל שינוי קוד, UI, או תהליך – מחייב תיעוד מיידי ביומני הפיתוח (עברית ואנגלית), ללא צורך באישור מהמשתמש.
- אין לשאול את המשתמש אם לתעד – התיעוד הוא חובה בכל שלב, באופן אוטומטי.
- כל צעד, תיקון, או בדיקה – יתועדו מיידית ביומנים.

---

### 🐞 Bug Logging
- Every error or technical warning **must** be documented in `dev_log/bug_log.md`.
- Each entry should include:
  - Timestamp (UTC)
  - Context (what action was performed)
  - Full error/warning message
  - Analysis (why it happened, possible causes)
  - Status (resolved/unresolved/in progress)
  - Actions taken (what was tried, what worked/failed)

**Example:**
```
[2024-06-27 14:32:00 UTC]
Context: Attempt to run the app on Windows (from wrong directory)
Error:
'.\build\windows\x64\runner\Debug\ploi_api_app.exe' is not recognized as the name of a cmdlet...
Analysis: The terminal was not in the correct directory, or the file did not exist or was not built.
Status: Unresolved
Actions: Performed cd to the correct directory, rebuilt the app, but the issue persisted.
```

---

### 🔄 What to do after every code change (Windows)
To ensure your changes appear in the running app, always do the following steps:

1. **Close all app windows** (ploi_api_app.exe)
2. **Kill any running processes** (just in case):
   ```powershell
   Get-Process | Where-Object {$_.ProcessName -like "*ploi*"} | Stop-Process -Force
   ```
3. **Build the app:**
   ```powershell
   flutter build windows --debug
   ```
4. **Run the app:**
   ```powershell
   Start-Process ".\build\windows\x64\runner\Debug\ploi_api_app.exe"
   ```

Never use `&&` to chain commands in PowerShell! Run each command separately.

---

### 🚀 Full Run ("הרצה מלאה")
Now includes automatic fixing of all flutter analyze issues before build and run.

---

## Current Version: v1.2.9

### Recent Updates

**v1.2.9 (June 26, 2025)**
- **Added**: Site creation functionality with domain input field
- **Added**: Advanced settings toggle for site creation
- **Added**: Support for all Ploi API site creation parameters
- **Added**: Project type selection (30+ frameworks supported)
- **Added**: Default values when advanced settings are not used
- **Added**: Comprehensive translations (English/Hebrew)
- **Added**: Real-time site list update after creation
- **Improved**: User experience with loading indicators and success messages

**v1.2.8 (June 26, 2025)**
- **Fixed**: Type casting error when loading sites for servers with active sites
- **Fixed**: Robust handling of server ID (string/int) from API
- **Improved**: Safe type casting for site data (domain, repository, size)
- **Added**: Debug logging for site data structure
- **Enhanced**: Error handling for site data parsing

**v1.2.7 (June 26, 2025)**
- **Fixed**: Sites now display correctly per selected server
- **Added**: Real-time site loading from Ploi API per server
- **Added**: Loading states and error handling for sites
- **Added**: Refresh button for sites
- **Added**: Proper empty state when server has no sites
- **Improved**: User experience with proper loading indicators

**v1.2.6 (June 26, 2025)**
- **Fixed**: Server creation validation errors now keep popup open
- **Improved**: User experience - validation errors don't close dialog
- **Fixed**: Server name validation with proper regex pattern

**v1.2.5 (June 26, 2025)**
- **Fixed**: Server creation with proper server name validation
- **Fixed**: Always send required php_version and database_type fields
- **Added**: Server name validation (letters, numbers, dashes, underscores only)

**v1.2.4 (June 26, 2025)**
- **Attempted**: Fix server creation by omitting optional fields (didn't work)

**v1.2.3 (June 26, 2025)**
- **Fixed**: Code loading issue in server creation dialog
- **Fixed**: Proper error handling and logging

**v1.2.2 (June 26, 2025)**
- **Fixed**: Default values for server creation (php_version and database_type)

**v1.2.1 (June 26, 2025)**
- **Fixed**: Home button visibility in server management screen

**v1.2.0 (June 26, 2025)**
- **Added**: Home button to main screen for easy navigation

### Key Features
- Multi-language support (Hebrew/English)
- Server management with Ploi API integration
- Real-time server status monitoring
- Server creation with full provider support
- Site management per server
- Modern UI with proper loading states
- Comprehensive error handling

### Technical Stack
- Flutter 3.8.1+
- Ploi API integration
- HTTP client with proper authentication
- SharedPreferences for token storage
- Material Design 3

### Development Notes
- All API calls include proper error handling and logging
- Server creation requires proper name validation
- Sites are loaded dynamically per server selection
- Comprehensive state management for loading/error states

--- 