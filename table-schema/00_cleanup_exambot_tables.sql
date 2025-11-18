-- ============================================
-- CLEANUP SCRIPT - Run this FIRST if you have existing ExamBot tables
-- ============================================
--
-- This script drops all existing ExamBot tables to avoid conflicts
-- when running the main schema file.
--
-- ⚠️ WARNING: This will DELETE ALL DATA in these tables!
-- Only run this if you're setting up a fresh database or resetting.
--
-- ============================================

-- Drop tables in reverse order of dependencies
DROP TABLE IF EXISTS test_session_answers CASCADE;
DROP TABLE IF EXISTS test_sessions CASCADE;
DROP TABLE IF EXISTS user_question_progress CASCADE;
DROP TABLE IF EXISTS questions CASCADE;
DROP TABLE IF EXISTS subtopics CASCADE;
DROP TABLE IF EXISTS topics CASCADE;
DROP TABLE IF EXISTS exam_categories CASCADE;

-- Drop old/legacy tables if they exist
DROP TABLE IF EXISTS chapters CASCADE;
DROP TABLE IF EXISTS subjects CASCADE;
DROP TABLE IF EXISTS exams CASCADE;

-- Verify tables are dropped
DO $$
BEGIN
  RAISE NOTICE 'Cleanup complete. All ExamBot tables have been dropped.';
  RAISE NOTICE 'You can now run: exambot_correct_schema.sql';
END $$;
