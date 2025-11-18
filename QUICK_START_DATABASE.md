# 🚀 Quick Start - ExamBot Database Setup

This guide will help you set up the ExamBot database from scratch.

## ⚠️ IMPORTANT: Use the Correct Schema File!

**✅ USE:** `table-schema/exambot_correct_schema.sql`
**❌ DON'T USE:** `table-schema/exambot_schema.sql` (legacy, wrong table names)

## Step 1: Open Supabase SQL Editor

1. Go to your Supabase project dashboard
2. Click on **SQL Editor** in the left sidebar
3. Click **New Query**

## Step 2: Run the Schema File

Copy and paste the **ENTIRE contents** of this file into the SQL Editor:

```
table-schema/exambot_correct_schema.sql
```

Then click **Run** (or press Ctrl+Enter)

**⚠️ Note:** This script will automatically drop any existing ExamBot tables before creating new ones. This prevents type conflicts and ensures a clean setup.

### What This Creates:

- ✅ `exam_categories` - Stores UPSC, SSC, Banking, etc.
- ✅ `topics` - Main topics (History, Geography, etc.)
- ✅ `subtopics` - Subtopics under each topic
- ✅ `questions` - Your question bank
- ✅ `user_question_progress` - Track user bookmarks and attempts
- ✅ `test_sessions` - Store test session data
- ✅ `test_session_answers` - Store user answers
- ✅ All indexes for performance
- ✅ All triggers for auto-updates
- ✅ All RLS policies for security

## Step 3: Verify Schema Creation

Run this query to verify tables were created:

```sql
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_name IN (
    'exam_categories',
    'topics',
    'subtopics',
    'questions',
    'user_question_progress',
    'test_sessions',
    'test_session_answers'
  )
ORDER BY table_name;
```

You should see all 7 tables listed.

## Step 4: Load Sample Data

Copy and paste the **ENTIRE contents** of this file into the SQL Editor:

```
sample-data/exambot_comprehensive_sample_data.sql
```

Then click **Run** (or press Ctrl+Enter)

### What This Adds:

- 8 exam categories (UPSC, SSC, Banking, Railway, GATE, CAT, NEET, JEE)
- 25+ topics across all subjects
- 50+ subtopics
- 30 realistic sample questions with:
  - Detailed explanations
  - Proper difficulty levels
  - Year-wise organization (2023-2024)
  - Subject classification
  - Tags for filtering

## Step 5: Verify Data Import

Run these verification queries:

### Check exam categories:
```sql
SELECT * FROM exam_categories ORDER BY category_name;
```
**Expected:** 8 rows (UPSC, SSC, Banking, etc.)

### Check questions count:
```sql
SELECT exam, COUNT(*) as total_questions
FROM questions
GROUP BY exam
ORDER BY total_questions DESC;
```
**Expected:** Multiple rows showing question counts per exam

### Check by difficulty:
```sql
SELECT difficulty, COUNT(*) as count
FROM questions
GROUP BY difficulty;
```
**Expected:** Easy, Medium, Hard with counts

### Check sample question:
```sql
SELECT
  id,
  exam,
  subject,
  question,
  answer,
  difficulty
FROM questions
LIMIT 1;
```
**Expected:** Full question details displayed

## Step 6: Test in ExamBot UI

1. Open your PrepNX application
2. Navigate to ExamBot
3. Select an exam from dropdown (e.g., "UPSC Civil Services")
4. You should see filters populated:
   - Subjects (History, Geography, Polity, etc.)
   - Years (2023, 2024)
   - Difficulty (Easy, Medium, Hard)
5. Click "Start Practice"
6. You should see questions loaded!

## Troubleshooting

### Error: "relation already exists"

**Cause:** The schema file should automatically drop existing tables, but if this error occurs, you may have custom constraints.

**Solution:** The schema file (`exambot_correct_schema.sql`) now automatically drops existing tables at the start. Just run it again - it will clean up and recreate everything.

### Error: Foreign key constraint type mismatch

**Cause:** Old tables with different column types (UUID vs TEXT) still exist

**Solution:** Run the schema file again - it now includes automatic cleanup of old tables with incompatible types.

### Error: "relation does not exist" when loading sample data

**Cause:** Schema wasn't created first, or wrong schema file was used

**Solution:**
1. Make sure you ran `exambot_correct_schema.sql` (NOT `exambot_schema.sql`)
2. Verify tables exist with verification query from Step 3
3. Then load sample data again

### Error: "duplicate key value violates unique constraint"

**Cause:** Sample data was already loaded

**Solution:**
```sql
-- Clear existing sample data
DELETE FROM questions;
DELETE FROM subtopics;
DELETE FROM topics;
DELETE FROM exam_categories;

-- Then load sample data again
```

### No exams showing in dropdown

**Cause:** Either schema not created or sample data not loaded

**Solution:**
```sql
-- Check if exam_categories table exists and has data
SELECT COUNT(*) FROM exam_categories;
```
If returns 0, load sample data. If returns error, create schema first.

### Questions not loading in ExamBot

**Cause:** Questions table empty or filters too restrictive

**Solution:**
```sql
-- Check if questions exist
SELECT COUNT(*) FROM questions;

-- Check questions for specific exam
SELECT exam, COUNT(*) FROM questions GROUP BY exam;
```

## Common Commands

### View all tables:
```sql
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
```

### Count all questions:
```sql
SELECT COUNT(*) FROM questions;
```

### View question structure:
```sql
SELECT
  column_name,
  data_type
FROM information_schema.columns
WHERE table_name = 'questions'
ORDER BY ordinal_position;
```

### Clear all data (keep schema):
```sql
TRUNCATE TABLE test_session_answers CASCADE;
TRUNCATE TABLE test_sessions CASCADE;
TRUNCATE TABLE user_question_progress CASCADE;
TRUNCATE TABLE questions CASCADE;
TRUNCATE TABLE subtopics CASCADE;
TRUNCATE TABLE topics CASCADE;
TRUNCATE TABLE exam_categories CASCADE;
```

## Next Steps

After successful setup:

1. ✅ **Add more questions** - Use the sample data as a template
2. ✅ **Test all features** - Try practice mode, test mode, bookmarks
3. ✅ **Enable authentication** - Set up Supabase Auth for user features
4. ✅ **Customize exams** - Add your own exam categories
5. ✅ **Import from PDF** - Use the question importer to bulk import

## File Structure Reference

```
final-edu/
├── table-schema/
│   ├── exambot_correct_schema.sql  ⭐ USE THIS!
│   ├── exambot_schema.sql          ❌ DON'T USE (legacy)
│   ├── aptitude_schema.sql
│   └── README.md
├── sample-data/
│   ├── exambot_comprehensive_sample_data.sql  ⭐ USE THIS!
│   ├── seed_exambot_data.sql       (legacy)
│   └── README.md
└── QUICK_START_DATABASE.md         📖 YOU ARE HERE
```

## Need Help?

1. Check the detailed README files in `table-schema/` and `sample-data/`
2. Review the schema comments in `exambot_correct_schema.sql`
3. Check Supabase logs in Dashboard → Database → Logs
4. Verify RLS policies in Dashboard → Authentication → Policies

---

**Good luck! 🎉 Your ExamBot database should now be ready to use.**
